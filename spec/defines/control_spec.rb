describe 'orawls::control', :type => :define do

  describe "CentOS 11g default domain home" do
    let(:params){{:download_dir         => '/install',
                  :os_user              => 'oracle',
                  :os_group             => 'dba',
                  :middleware_home_dir  => '/opt/oracle/middleware11gR1',
                  :weblogic_home_dir    => '/opt/oracle/middleware11gR1/wlserver_103',
                  :jdk_home_dir         => '/usr/java/jdk1.7.0_45',
                  :jsse_enabled         => true,
                  :server_type          => 'admin',
                  :target               => 'Server',
                  :server               => 'AdminServer',
                  :domain_name          => 'wls',
                  :adminserver_address  => '10.10.10.100',
                  :adminserver_port     => 7001,
                  :nodemanager_port     => 5556,
                  :action               => 'start',
                  :weblogic_user        => "weblogic",
                  :weblogic_password    => "weblogic1",
                }}
    let(:title) {'controlAdmin'}
    let(:facts) {{ :operatingsystem => 'CentOS' ,
                   :kernel          => 'Linux',
                   :osfamily        => 'RedHat' }}


    describe "WLST script" do
      it { 
           should contain_file("/install/controlAdminstartWlsServer2.py").with({
             'ensure'  => 'present',
             'path'    => "/install/controlAdminstartWlsServer2.py",
             'owner'   => 'oracle',
             'group'   => 'dba',
             'content' => "# python script wls:wlscontrol\n\nwlsUser    = 'weblogic'\npassword   = sys.argv[1] \nmachine    = '10.10.10.100'\nportNumber = '5556'\n\ndomain     = 'wls'\ndomainPath = '/opt/oracle/middleware11gR1/user_projects/domains/wls'\nwlsServer  = 'AdminServer'\n\nnmConnect(wlsUser,password,machine,portNumber,domain,domainPath,'ssl')\n\n#start the WlsServer\nnmStart(wlsServer)\n\n#Ask the status of the WlsServer\nnmServerStatus(wlsServer)\n\n#disconnect from the nodemanager\nnmDisconnect()\n",
           }) 
         }  
    end

    describe "start adminserver" do
      it { 
           should contain_exec("execwlst controlAdminstartWlsServer2.py ").with({
             'command'     => 'java  -Dweblogic.ssl.JSSEEnabled=true -Dweblogic.security.SSL.enableJSSE=true -Dweblogic.security.SSL.ignoreHostnameVerification=true weblogic.WLST -skipWLSModuleScanning  /install/controlAdminstartWlsServer2.py weblogic1',
             'user'        => 'oracle',
             'group'       => 'dba',
             'environment' => ["CLASSPATH=/opt/oracle/middleware11gR1/wlserver_103/server/lib/weblogic.jar","JAVA_HOME=/usr/java/jdk1.7.0_45"],
           }).that_requires('File[/install/controlAdminstartWlsServer2.py]') 
         }  
    end

  end

  describe "CentOS 11g start soa_server1" do
    let(:params){{:download_dir         => '/install',
                  :os_user              => 'oracle',
                  :os_group             => 'dba',
                  :middleware_home_dir  => '/opt/oracle/middleware11gR1',
                  :weblogic_home_dir    => '/opt/oracle/middleware11gR1/wlserver_103',
                  :jdk_home_dir         => '/usr/java/jdk1.7.0_45',
                  :jsse_enabled         => true,
                  :server_type          => 'managed',
                  :target               => 'Server',
                  :server               => 'soa_server1',
                  :domain_name          => 'wls',
                  :adminserver_address  => '10.10.10.100',
                  :adminserver_port     => 7001,
                  :nodemanager_port     => 5556,
                  :action               => 'start',
                  :weblogic_user        => "weblogic",
                  :weblogic_password    => "weblogic1",
                }}
    let(:title) {'controlsoa'}
    let(:facts) {{ :operatingsystem => 'CentOS' ,
                   :kernel          => 'Linux',
                   :osfamily        => 'RedHat' }}


    describe "WLST script" do
      it { 
           should contain_file("/install/controlsoastartWlsManagedServer2.py").with({
             'ensure'  => 'present',
             'path'    => "/install/controlsoastartWlsManagedServer2.py",
             'owner'   => 'oracle',
             'group'   => 'dba',
             'content' => "# python script wls:wlscontrol\n\nwlsUser    = 'weblogic'\npassword   = sys.argv[1] \nmachine    = '10.10.10.100'\nportNumber = '7001'\n\nwlsServer  = 'soa_server1'\nwlsTarget  = 'Server'\n\nconnect(wlsUser,password,'t3://'+machine+':'+portNumber)\n\n#start the WlsServer\nstart(wlsServer,wlsTarget)\n",
           }) 
         }  
    end

    describe "start soaserver" do
      it { 
           should contain_exec("execwlst controlsoastartWlsManagedServer2.py ").with({
             'command'     => 'java  -Dweblogic.ssl.JSSEEnabled=true -Dweblogic.security.SSL.enableJSSE=true -Dweblogic.security.SSL.ignoreHostnameVerification=true weblogic.WLST -skipWLSModuleScanning  /install/controlsoastartWlsManagedServer2.py weblogic1',
             'user'        => 'oracle',
             'group'       => 'dba',
             'environment' => ["CLASSPATH=/opt/oracle/middleware11gR1/wlserver_103/server/lib/weblogic.jar","JAVA_HOME=/usr/java/jdk1.7.0_45"],
           }).that_requires('File[/install/controlsoastartWlsManagedServer2.py]') 
         }  
    end


  end

  describe "CentOS 11g stop soa cluster" do
    let(:params){{:download_dir         => '/install',
                  :os_user              => 'oracle',
                  :os_group             => 'dba',
                  :middleware_home_dir  => '/opt/oracle/middleware11gR1',
                  :weblogic_home_dir    => '/opt/oracle/middleware11gR1/wlserver_103',
                  :jdk_home_dir         => '/usr/java/jdk1.7.0_45',
                  :jsse_enabled         => true,
                  :server_type          => 'managed',
                  :target               => 'Cluster',
                  :server               => 'soa_cluster',
                  :domain_name          => 'wls',
                  :adminserver_address  => '10.10.10.100',
                  :adminserver_port     => 7001,
                  :nodemanager_port     => 5556,
                  :action               => 'stop',
                  :weblogic_user        => "weblogic",
                  :weblogic_password    => "weblogic1",
                }}
    let(:title) {'controlsoa'}
    let(:facts) {{ :operatingsystem => 'CentOS' ,
                   :kernel          => 'Linux',
                   :osfamily        => 'RedHat' }}


    describe "WLST script" do
      it { 
           should contain_file("/install/controlsoastopWlsManagedServer2.py").with({
             'ensure'  => 'present',
             'path'    => "/install/controlsoastopWlsManagedServer2.py",
             'owner'   => 'oracle',
             'group'   => 'dba',
             'content' => "# python script wls:wlscontrol\n\nwlsUser    = 'weblogic'\npassword   = sys.argv[1] \nmachine    = '10.10.10.100'\nportNumber = '7001'\n\nwlsServer  = 'soa_cluster'\nwlsTarget  = 'Cluster'\n\nconnect(wlsUser,password,'t3://'+machine+':'+portNumber)\n\n#start the WlsServer\nshutdown(wlsServer,wlsTarget,force='true')\n",
           }) 
         }  
    end

    describe "stop cluster" do
      it { 
           should contain_exec("execwlst controlsoastopWlsManagedServer2.py ").with({
             'command'     => 'java  -Dweblogic.ssl.JSSEEnabled=true -Dweblogic.security.SSL.enableJSSE=true -Dweblogic.security.SSL.ignoreHostnameVerification=true weblogic.WLST -skipWLSModuleScanning  /install/controlsoastopWlsManagedServer2.py weblogic1',
             'user'        => 'oracle',
             'group'       => 'dba',
             'environment' => ["CLASSPATH=/opt/oracle/middleware11gR1/wlserver_103/server/lib/weblogic.jar","JAVA_HOME=/usr/java/jdk1.7.0_45"],
           }).that_requires('File[/install/controlsoastopWlsManagedServer2.py]') 
         }  
    end

  end

  describe "CentOS 12c custom domain home" do
    let(:params){{:download_dir         => '/install',
                  :os_user              => 'oracle',
                  :os_group             => 'dba',
                  :middleware_home_dir  => '/opt/oracle/middleware12c',
                  :weblogic_home_dir    => '/opt/oracle/middleware12c/wlserver',
                  :jdk_home_dir         => '/usr/java/jdk1.7.0_45',
                  :jsse_enabled         => true,
                  :server_type          => 'admin',
                  :target               => 'Server',
                  :server               => 'AdminServer',
                  :adminserver_address  => '10.10.10.100',
                  :adminserver_port     => 7001,
                  :nodemanager_port     => 5556,
                  :action               => 'start',
                  :weblogic_user        => "weblogic",
                  :weblogic_password    => "weblogic1",
                  :wls_domains_dir      => '/opt/oracle/wlsdomains/domains',
                  :domain_name          => 'wls',
                }}
    let(:title) {'control12cadmin'}
    let(:facts) {{ :operatingsystem => 'CentOS' ,
                   :kernel          => 'Linux',
                   :osfamily        => 'RedHat' }}


    describe "WLST script" do
      it { 
           should contain_file("/install/control12cadminstartWlsServer2.py").with({
             'ensure'  => 'present',
             'path'    => "/install/control12cadminstartWlsServer2.py",
             'owner'   => 'oracle',
             'group'   => 'dba',
             'content' => "# python script wls:wlscontrol\n\nwlsUser    = 'weblogic'\npassword   = sys.argv[1] \nmachine    = '10.10.10.100'\nportNumber = '5556'\n\ndomain     = 'wls'\ndomainPath = '/opt/oracle/wlsdomains/domains/wls'\nwlsServer  = 'AdminServer'\n\nnmConnect(wlsUser,password,machine,portNumber,domain,domainPath,'ssl')\n\n#start the WlsServer\nnmStart(wlsServer)\n\n#Ask the status of the WlsServer\nnmServerStatus(wlsServer)\n\n#disconnect from the nodemanager\nnmDisconnect()\n",
           }) 
         }  
    end

    describe "start adminserver" do
      it { 
           should contain_exec("execwlst control12cadminstartWlsServer2.py ").with({
             'command'     => 'java  -Dweblogic.ssl.JSSEEnabled=true -Dweblogic.security.SSL.enableJSSE=true -Dweblogic.security.SSL.ignoreHostnameVerification=true weblogic.WLST -skipWLSModuleScanning  /install/control12cadminstartWlsServer2.py weblogic1',
             'user'        => 'oracle',
             'group'       => 'dba',
             'environment' => ["CLASSPATH=/opt/oracle/middleware12c/wlserver/server/lib/weblogic.jar","JAVA_HOME=/usr/java/jdk1.7.0_45"],
           }).that_requires('File[/install/control12cadminstartWlsServer2.py]') 
         }  
    end


  end

  describe "CentOS 12c stop custom domain home" do
    let(:params){{:download_dir         => '/install',
                  :os_user              => 'oracle',
                  :os_group             => 'dba',
                  :middleware_home_dir  => '/opt/oracle/middleware11gR1',
                  :weblogic_home_dir    => '/opt/oracle/middleware11gR1/wlserver_103',
                  :jdk_home_dir         => '/usr/java/jdk1.7.0_45',
                  :jsse_enabled         => true,
                  :server_type          => 'admin',
                  :target               => 'Server',
                  :server               => 'AdminServer',
                  :adminserver_address  => '10.10.10.100',
                  :adminserver_port     => 7001,
                  :nodemanager_port     => 5556,
                  :action               => 'stop',
                  :weblogic_user        => "weblogic",
                  :weblogic_password    => "weblogic1",
                  :wls_domains_dir      => '/opt/oracle/wlsdomains/domains',
                  :domain_name          => 'wls',
                }}
    let(:title) {'control12cadmin'}
    let(:facts) {{ :operatingsystem => 'CentOS' ,
                   :kernel          => 'Linux',
                   :osfamily        => 'RedHat' }}


    describe "WLST script" do
      it { 
           should contain_file("/install/control12cadminstopWlsServer2.py").with({
             'ensure'  => 'present',
             'path'    => "/install/control12cadminstopWlsServer2.py",
             'owner'   => 'oracle',
             'group'   => 'dba',
             'content' => "# python script wls:wlscontrol\n\nwlsUser    = 'weblogic'\npassword   = sys.argv[1] \nmachine    = '10.10.10.100'\nportNumber = '5556'\n\ndomain     = 'wls'\ndomainPath = '/opt/oracle/wlsdomains/domains/wls'\nwlsServer  = 'AdminServer'\n\nnmConnect(wlsUser,password,machine,portNumber,domain,domainPath,'ssl')\n\n#start the WlsServer\nnmKill(wlsServer)\n\n#disconnect from the nodemanager\nnmDisconnect()\n",
           }) 
         }  
    end

    describe "stop adminserver" do
      it { 
           should contain_exec("execwlst control12cadminstopWlsServer2.py ").with({
             'command'     => 'java  -Dweblogic.ssl.JSSEEnabled=true -Dweblogic.security.SSL.enableJSSE=true -Dweblogic.security.SSL.ignoreHostnameVerification=true weblogic.WLST -skipWLSModuleScanning  /install/control12cadminstopWlsServer2.py weblogic1',
             'user'        => 'oracle',
             'group'       => 'dba',
             'environment' => ["CLASSPATH=/opt/oracle/middleware11gR1/wlserver_103/server/lib/weblogic.jar", "JAVA_HOME=/usr/java/jdk1.7.0_45"],
           }).that_requires('File[/install/control12cadminstopWlsServer2.py]') 
         }  
    end


  end

end