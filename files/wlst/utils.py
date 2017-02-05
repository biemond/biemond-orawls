

def create_boot_properties_file(directory_path, file_name, username, password):
    server_dir = File(directory_path)
    server_dir.mkdirs()
    full_file_name = directory_path + '/' + file_name
    file_new = open(full_file_name, 'w')
    file_new.write('username=%s\n' % username)
    file_new.write('password=%s\n' % password)
    file_new.flush()
    file_new.close()
    os.system('chmod 600 ' + full_file_name)


def create_admin_startup_properties_file(directory_path, args):
    adminserver_dir = File(directory_path)
    adminserver_dir.mkdirs()
    full_file_name = directory_path + '/startup.properties'
    file_new = open(full_file_name, 'w')
    args = args.replace(':', '\\:')
    args = args.replace('=', '\\=')
    file_new.write('Arguments=%s\n' % args)
    file_new.flush()
    file_new.close()
    os.system('chmod 600 ' + full_file_name)


def create_machine(machine_type, name, address, nodemanager_secure_listener):
    cd('/')
    create(name, machine_type)
    cd(machine_type + '/' + name)
    create(name, 'NodeManager')
    cd('NodeManager/' + name)

    if nodemanager_secure_listener == True:
        set('NMType', 'SSL')
    else:
        set('NMType', 'Plain')

    set('ListenAddress', address)


def change_datasource(datasource, username, password, db_url):
    print 'Change datasource ' + datasource
    cd('/')
    cd('/JDBCSystemResource/' + datasource + '/JdbcResource/' + datasource + '/JDBCDriverParams/NO_NAME_0')
    set('URL', db_url)
    set('PasswordEncrypted', password)
    cd('Properties/NO_NAME_0/Property/user')
    set('Value', username)
    cd('/')


def change_datasource_driver(datasource, username, password, db_url):
    print 'change_datasource_driver ' + datasource
    cd('/')
    cd('/JDBCSystemResource/' + datasource + '/JdbcResource/' + datasource + '/JDBCDriverParams/NO_NAME_0')
    set('URL', db_url)
    set('DriverName', 'oracle.jdbc.OracleDriver')
    set('PasswordEncrypted', password)
    cd('Properties/NO_NAME_0/Property/user')
    set('Value', username)
    cd('/')


def change_datasource_to_xa(datasource):
    print 'change_datasource_to_xa ' + datasource
    cd('/')
    cd('/JDBCSystemResource/' + datasource + '/JdbcResource/' + datasource + '/JDBCDriverParams/NO_NAME_0')
    set('DriverName', 'oracle.jdbc.xa.client.OracleXADataSource')
    set('UseXADataSourceInterface', 'True')
    cd('/JDBCSystemResource/' + datasource + '/JdbcResource/' + datasource + '/JDBCDataSourceParams/NO_NAME_0')
    set('GlobalTransactionsProtocol', 'TwoPhaseCommit')
    cd('/')


def create_opss_datasource(target, prefix, password, db_url):
    cd('/')
    create('opssDataSource', 'JDBCSystemResource')
    cd('/JDBCSystemResource/opssDataSource')
    set('Target', target)

    cd('/JDBCSystemResource/opssDataSource/JdbcResource/opssDataSource')
    cmo.setName('opssDataSource')

    cd('/JDBCSystemResource/opssDataSource/JdbcResource/opssDataSource')
    create('myJdbcDataSourceParams', 'JDBCDataSourceParams')
    cd('JDBCDataSourceParams/NO_NAME_0')
    set('JNDIName', 'jdbc/opssDataSource')
    set('GlobalTransactionsProtocol', 'None')

    cd('/JDBCSystemResource/opssDataSource/JdbcResource/opssDataSource')
    create('myJdbcDriverParams', 'JDBCDriverParams')
    cd('JDBCDriverParams/NO_NAME_0')
    set('DriverName', 'oracle.jdbc.OracleDriver')
    set('URL', db_url)
    set('PasswordEncrypted', password)
    set('UseXADataSourceInterface', 'false')

    create('myProperties', 'Properties')
    cd('Properties/NO_NAME_0')
    create('user', 'Property')
    cd('Property')
    cd('user')
    set('Value', prefix + '_OPSS')

    cd('/JDBCSystemResource/opssDataSource/JdbcResource/opssDataSource')
    create('myJdbcConnectionPoolParams', 'JDBCConnectionPoolParams')
    cd('JDBCConnectionPoolParams/NO_NAME_0')
    set('TestTableName', 'SQL SELECT 1 FROM DUAL')


def change_log(wls_type, name, log_folder):
    if wls_type == 'server':
        cd('/Server/' + name)
        create(name, 'Log')
        cd('/Server/' + name + '/Log/' + name)
    else:
        cd('/')
        create('base_domain', 'Log')
        cd('/Log/base_domain')

    set('FileName', log_folder + '/' + name + '.log')
    set('FileCount', 10)
    set('FileMinSize', 5000)
    set('RotationType', 'byTime')
    set('FileTimeSpan', 24)


def change_ssl_with_port(server, jsse_enabled, ssl_listen_port):
    cd('/Server/' + server)
    create(server, 'SSL')
    cd('SSL/' + server)
    set('HostNameVerificationIgnored', 'True')

    if ssl_listen_port:
        set('Enabled', 'True')
        set('ListenPort', int(ssl_listen_port))
    else:
        set('Enabled', 'False')

    if jsse_enabled == True:
        set('JSSEEnabled', 'True')
    else:
        set('JSSEEnabled', 'False')


def change_ssl(server, jsse_enabled):
    change_ssl_with_port(server, jsse_enabled, None)


def change_server_arguments(server, java_arguments):
    print 'change_server_arguments for server ' + server
    cd('/Servers/' + server)
    cd('ServerStart/' + server)
    set('Arguments', java_arguments)


def change_default_server_attributes(server, machine, address, port, java_arguments, java_home):
    print 'change_default_server_attributes for server ' + server
    cd('/Servers/' + server)

    if machine:
        set('Machine', machine)
    if address:
        set('ListenAddress', address)
    if port:
        set('ListenPort', port)

    create(server, 'ServerStart')
    cd('ServerStart/' + server)
    set('Arguments', java_arguments)
    set('JavaVendor', 'Sun')
    set('JavaHome', java_home)


def change_managed_server(server, machine, address, port, java_arguments, log_folder, java_home, jsse_enabled):
    change_default_server_attributes(server, machine, address, port, java_arguments, java_home)
    change_ssl(server, jsse_enabled)
    change_log('server', server, log_folder)


def change_admin_server(adminserver, machine, address, port, java_arguments, java_home):
    cd('/Servers/AdminServer')
    set('Name', adminserver)
    change_default_server_attributes(adminserver, machine, address, port, java_arguments, java_home)


def change_custom_identity_store(server, ks_filename, ks_passphrase, trust_ks_filename, trust_ks_passphrase, alias, alias_passphrase):
    print 'set custom identity'
    cd('/Server/' + server)
    set('KeyStores', 'CustomIdentityAndCustomTrust')
    set('CustomIdentityKeyStoreFileName', ks_filename)
    set('CustomIdentityKeyStorePassPhraseEncrypted', ks_passphrase)
    set('CustomTrustKeyStoreFileName', trust_ks_filename)
    set('CustomTrustKeyStorePassPhraseEncrypted', trust_ks_passphrase)
    cd('SSL/' + server)
    set('ServerPrivateKeyAlias', alias)
    set('ServerPrivateKeyPassPhraseEncrypted', alias_passphrase)


def set_domain_password(domain, password):
    print 'set domain password...'
    cd('/SecurityConfiguration/' + domain)
    set('CredentialEncrypted', password)


def set_nodemanager_password(domain, password, username):
    print 'set nodemanager password...'
    cd('/SecurityConfiguration/' + domain)
    set('NodeManagerUsername', username)
    set('NodeManagerPasswordEncrypted', password)


def set_weblogic_password(username, password):
    print 'set weblogic password...'
    cd('/Security/base_domain/User/weblogic')
    set('Name', username)
    cmo.setPassword(password)


def set_cross_domain():
    print 'set crossdomain'
    cd('/')
    create('base_domain', 'SecurityConfiguration')
    cd('/SecurityConfiguration/base_domain')
    set('CrossDomainSecurityEnabled', 'True')
