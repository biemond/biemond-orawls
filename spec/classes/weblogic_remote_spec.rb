require 'spec_helper'

describe 'orawls::weblogic', :type => :class do

  describe "weblogic remote install" do
    let(:params){{
                  :version              => 1036,
                  :download_dir         => '/install',
                  :filename             => 'wls1036_generic.jar',
                  :os_user              => 'oracle',
                  :os_group             => 'dba',
                  :middleware_home_dir  => '/opt/oracle/middleware11gR1',
                  :oracle_base_home_dir => '/opt/oracle', 
                  :jdk_home_dir         => '/usr/java/jdk1.7.0_45',
                  :remote_file          => true,
                  :source               => 'puppet:///middleware',
                  :temp_directory       => '/data',
                }}
    let(:facts) {{ :operatingsystem => 'CentOS' ,
                   :kernel          => 'Linux',
                   :osfamily        => 'RedHat' }}

    describe "WebLogic orainst" do
      it do 
        should contain_orawls__utils__orainst("weblogic orainst 1036").with({
             'ora_inventory_dir'  => '/opt/oracle/oraInventory',
             'os_group'           => 'dba',
           })
      end
    end

    describe "WebLogic structure" do
      it do 
        should contain_orawls__utils__structure("weblogic structure 1036").with({
             'oracle_base_home_dir' => '/opt/oracle',
             'ora_inventory_dir'    => '/opt/oracle/oraInventory',
             'os_group'             => 'dba',
             'os_user'              => 'oracle',
             'download_dir'         => '/install',
             'wls_domains_dir'      => nil,
             'wls_apps_dir'         => nil,
           })
      end
    end

    describe "download weblogic.jar" do
      it { 
           should contain_file("/install/wls1036_generic.jar").with({
             'source'  => 'puppet:///middleware/wls1036_generic.jar',
           })
         }  
    end

    describe "weblogic silent file" do
      it do 
           should contain_file("/install/weblogic_silent_install.xml").with({
             'content' => "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n   <bea-installer> \n     <input-fields>\n       <data-value name=\"BEAHOME\" value=\"/opt/oracle/middleware11gR1\" />\n   </input-fields> \n</bea-installer>",
           })
      end
    end

    describe "install weblogic" do
      it { 
           should contain_exec("install weblogic 1036").with({
             'command'      => 'java  -Xmx1024m -Djava.io.tmpdir=/data -jar /install/wls1036_generic.jar -Djava.io.tmpdir=/data -mode=silent -silent_xml=/install/weblogic_silent_install.xml',
             'environment'  => ["JAVA_VENDOR=Sun","JAVA_HOME=/usr/java/jdk1.7.0_45"],
           }).that_requires('File[/install/weblogic_silent_install.xml]').that_requires('Orawls::Utils::Structure[weblogic structure 1036]')     
         }  
    end
 
  end

  describe "weblogic domains params" do
    let(:params){{
                  :version              => 1036,
                  :download_dir         => '/install',
                  :filename             => 'wls1036_generic.jar',
                  :os_user              => 'oracle',
                  :os_group             => 'dba',
                  :middleware_home_dir  => '/opt/oracle/middleware11gR1',
                  :oracle_base_home_dir => '/opt/oracle', 
                  :jdk_home_dir         => '/usr/java/jdk1.7.0_45',
                  :remote_file          => true,
                  :source               => 'puppet:///middleware',
                  :temp_directory       => '/data',
                  :wls_domains_dir      => '/opt/oracle/wlsdomains/domains',
                  :wls_apps_dir         => '/opt/oracle/wlsdomains/applications',
                }}
    let(:facts) {{ :operatingsystem => 'CentOS' ,
                   :kernel          => 'Linux',
                   :osfamily        => 'RedHat' }}


    describe "WebLogic structure" do
      it do 
        should contain_orawls__utils__structure("weblogic structure 1036").with({
             'oracle_base_home_dir' => '/opt/oracle',
             'ora_inventory_dir'    => '/opt/oracle/oraInventory',
             'os_group'             => 'dba',
             'os_user'              => 'oracle',
             'download_dir'         => '/install',
             'wls_domains_dir'      => '/opt/oracle/wlsdomains/domains',
             'wls_apps_dir'         => '/opt/oracle/wlsdomains/applications',
           })
      end
    end


  end


  describe "weblogic local install" do
    let(:params){{
                  :version              => 1036,
                  :download_dir         => '/install',
                  :filename             => 'wls1036_generic.jar',
                  :os_user              => 'oracle',
                  :os_group             => 'dba',
                  :middleware_home_dir  => '/opt/oracle/middleware11gR1',
                  :oracle_base_home_dir => '/opt/oracle', 
                  :jdk_home_dir         => '/usr/java/jdk1.7.0_45',
                  :remote_file          => false,
                  :source               => '/software',
                }}
    let(:facts) {{ :operatingsystem => 'CentOS' ,
                   :kernel          => 'Linux',
                   :osfamily        => 'RedHat' }}

    describe "WebLogic orainst" do
      it do 
        should contain_orawls__utils__orainst("weblogic orainst 1036").with({
             'ora_inventory_dir'  => '/opt/oracle/oraInventory',
             'os_group'           => 'dba',
           })
      end
    end

    describe "WebLogic structure" do
      it do 
        should contain_orawls__utils__structure("weblogic structure 1036").with({
             'oracle_base_home_dir' => '/opt/oracle',
             'ora_inventory_dir'    => '/opt/oracle/oraInventory',
             'os_group'             => 'dba',
             'os_user'              => 'oracle',
             'download_dir'         => '/install',
             'wls_domains_dir'      => nil,
             'wls_apps_dir'         => nil,
           })
      end
    end

    describe "weblogic silent file" do
      it do 
           should contain_file("/install/weblogic_silent_install.xml").with({
             'content' => "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n   <bea-installer> \n     <input-fields>\n       <data-value name=\"BEAHOME\" value=\"/opt/oracle/middleware11gR1\" />\n   </input-fields> \n</bea-installer>",
           })
      end
    end

    describe "install weblogic" do
      it { 
           should contain_exec("install weblogic 1036").with({
             'command'      => 'java  -Xmx1024m -Djava.io.tmpdir=/tmp -jar /software/wls1036_generic.jar -Djava.io.tmpdir=/tmp -mode=silent -silent_xml=/install/weblogic_silent_install.xml',
             'environment'  => ["JAVA_VENDOR=Sun","JAVA_HOME=/usr/java/jdk1.7.0_45"],
           }).that_requires('File[/install/weblogic_silent_install.xml]').that_requires('Orawls::Utils::Structure[weblogic structure 1036]')     
         }  
    end
 
  end

  describe "weblogic local 12.1.2 install" do
    let(:params){{
                  :version              => 1212,
                  :download_dir         => '/install',
                  :filename             => 'wls_121200.jar',
                  :os_user              => 'oracle',
                  :os_group             => 'dba',
                  :middleware_home_dir  => '/opt/oracle/middleware11gR1',
                  :oracle_base_home_dir => '/opt/oracle', 
                  :jdk_home_dir         => '/usr/java/jdk1.7.0_45',
                  :remote_file          => false,
                  :source               => '/software',
                }}
    let(:facts) {{ :operatingsystem => 'CentOS' ,
                   :kernel          => 'Linux',
                   :osfamily        => 'RedHat' }}

    describe "WebLogic orainst" do
      it do 
        should contain_orawls__utils__orainst("weblogic orainst 1212").with({
             'ora_inventory_dir'  => '/opt/oracle/oraInventory',
             'os_group'           => 'dba',
           })
      end
    end

    describe "WebLogic structure" do
      it do 
        should contain_orawls__utils__structure("weblogic structure 1212").with({
             'oracle_base_home_dir' => '/opt/oracle',
             'ora_inventory_dir'    => '/opt/oracle/oraInventory',
             'os_group'             => 'dba',
             'os_user'              => 'oracle',
             'download_dir'         => '/install',
             'wls_domains_dir'      => nil,
             'wls_apps_dir'         => nil,
           })
      end
    end

    describe "weblogic silent file" do
      it do 
           should contain_file("/install/weblogic_silent_install.xml").with({
             'content' => "[ENGINE]\nResponse File Version=1.0.0.0.0\n[GENERIC]\n\n#The oracle home location. This can be an existing Oracle Home or a new Oracle Home\nORACLE_HOME=/opt/oracle/middleware11gR1\n#Set this variable value to the Installation Type selected. e.g. WebLogic Server, Coherence, Complete with Examples.\nINSTALL_TYPE=WebLogic Server\n \n#Provide the My Oracle Support Username. If you wish to ignore Oracle Configuration Manager configuration provide empty string for user name.\nMYORACLESUPPORT_USERNAME=\n#Provide the My Oracle Support Password\nMYORACLESUPPORT_PASSWORD=<SECURE VALUE>\n#Set this to true if you wish to decline the security updates. Setting this to true and providing empty string for My Oracle Support username will ignore the Oracle Configuration Manager configuration\nDECLINE_SECURITY_UPDATES=true\n#Set this to true if My Oracle Support Password is specified\nSECURITY_UPDATES_VIA_MYORACLESUPPORT=false\n",
           })
      end
    end

    describe "install weblogic" do
      it { 
           should contain_exec("install weblogic 1212").with({
             'command'      => 'java  -Xmx1024m -Djava.io.tmpdir=/tmp -jar /software/wls_121200.jar -Djava.io.tmpdir=/tmp -silent -responseFile /install/weblogic_silent_install.xml  -invPtrLoc /etc/oraInst.loc -ignoreSysPrereqs',
             'environment'  => ["JAVA_VENDOR=Sun","JAVA_HOME=/usr/java/jdk1.7.0_45"],
           }).that_requires('File[/install/weblogic_silent_install.xml]').that_requires('Orawls::Utils::Structure[weblogic structure 1212]').that_requires('Orawls::Utils::Orainst[weblogic orainst 1212]')    
         }  
    end
 
 
  end

end