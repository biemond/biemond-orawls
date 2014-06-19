require 'spec_helper'

describe 'orawls::nodemanager', :type => :define do


  describe "CentOS 11g" do
    let(:params){{:version              => 1111,
                  :download_dir         => '/install',
                  :os_user              => 'oracle',
                  :os_group             => 'dba',
                  :middleware_home_dir  => '/opt/oracle/middleware11gR1',
                  :weblogic_home_dir    => '/opt/oracle/middleware11gR1/wlserver_103',
                  :jdk_home_dir         => '/usr/java/jdk1.7.0_45',
                  :nodemanager_port     => 5556,
                  :nodemanager_address  => '10.10.10.100',
                  :jsse_enabled         => true,
                }}
    let(:title) {'nodemanager11g'}
    let(:facts) {{ :operatingsystem => 'CentOS' ,
                   :kernel          => 'Linux',
                   :osfamily        => 'RedHat' }}

    describe "nodemanager.properties" do
      it { 
           should contain_file("nodemanager.properties ux nodemanager11g").with({
             'ensure'  => 'present',
             'path'    => "/opt/oracle/middleware11gR1/wlserver_103/common/nodemanager/nodemanager.properties",
             'owner'   => 'oracle',
             'group'   => 'dba',
           }).that_comes_before('Exec[startNodemanager nodemanager11g]')  
         }  
    end

    describe "start nodemanager 1" do
      it { 
           should contain_exec("startNodemanager nodemanager11g").with({
             'command'     => 'nohup /opt/oracle/middleware11gR1/wlserver_103/server/bin/startNodeManager.sh &',
             'cwd'         => '/opt/oracle/middleware11gR1/wlserver_103/common/nodemanager',
             'user'        => 'oracle',
             'group'       => 'dba',
             'environment' => ["JAVA_OPTIONS=-Dweblogic.ssl.JSSEEnabled=true -Dweblogic.security.SSL.enableJSSE=true ", "JAVA_HOME=/usr/java/jdk1.7.0_45", "JAVA_VENDOR=Oracle"],
           })
         }  
    end

  end

  describe "CentOS 11g log dir" do
    let(:params){{:version              => 1111,
                  :download_dir         => '/install',
                  :os_user              => 'oracle',
                  :os_group             => 'dba',
                  :middleware_home_dir  => '/opt/oracle/middleware11gR1',
                  :weblogic_home_dir    => '/opt/oracle/middleware11gR1/wlserver_103',
                  :jdk_home_dir         => '/usr/java/jdk1.7.0_45',
                  :nodemanager_port     => 5556,
                  :nodemanager_address  => '10.10.10.100',
                  :jsse_enabled         => false,
                  :log_dir              => '/var/log/weblogic',
                }}
    let(:title) {'nodemanager11g'}
    let(:facts) {{ :operatingsystem => 'CentOS' ,
                   :kernel          => 'Linux',
                   :osfamily        => 'RedHat' }}


    describe "create logdir" do
      it { 
           should contain_exec("create /var/log/weblogic directory").with({
             'command'  => 'mkdir -p /var/log/weblogic',
             'cwd'      => '/opt/oracle/middleware11gR1/wlserver_103/common/nodemanager',
           })
         }  
    end

    describe "change logdir" do
      it { 
           should contain_file("/var/log/weblogic").with({
             'ensure'  => 'directory',
             'owner'   => 'oracle',
             'group'   => 'dba',
           }).that_requires('Exec[create /var/log/weblogic directory]')  
         }  
    end

    describe "nodemanager.properties" do
      it { 
           should contain_file("nodemanager.properties ux nodemanager11g").with({
             'ensure'  => 'present',
             'path'    => "/opt/oracle/middleware11gR1/wlserver_103/common/nodemanager/nodemanager.properties",
             'owner'   => 'oracle',
             'group'   => 'dba',
           }).that_comes_before('Exec[startNodemanager nodemanager11g]')  
         }  
    end

    describe "start nodemanager 2" do
      it { 
           should contain_exec("startNodemanager nodemanager11g").with({
             'command'     => 'nohup /opt/oracle/middleware11gR1/wlserver_103/server/bin/startNodeManager.sh &',
             'cwd'         => '/opt/oracle/middleware11gR1/wlserver_103/common/nodemanager',
             'user'        => 'oracle',
             'group'       => 'dba',
             'environment' => ["JAVA_OPTIONS=-Dweblogic.ssl.JSSEEnabled=false -Dweblogic.security.SSL.enableJSSE=false ", "JAVA_HOME=/usr/java/jdk1.7.0_45", "JAVA_VENDOR=Oracle"],
           })
         }  
    end

  end  

  describe "CentOS 12.1.2 log dir" do
    let(:params){{:version              => 1212,
                  :download_dir         => '/install',
                  :os_user              => 'oracle',
                  :os_group             => 'dba',
                  :middleware_home_dir  => '/opt/oracle/middleware11gR1',
                  :weblogic_home_dir    => '/opt/oracle/middleware11gR1/wlserver_103',
                  :jdk_home_dir         => '/usr/java/jdk1.7.0_45',
                  :nodemanager_port     => 5556,
                  :nodemanager_address  => '10.10.10.100',
                  :jsse_enabled         => false,
                  :wls_domains_dir      => '/opt/oracle/wlsdomains/domains',
                  :domain_name          => 'wls1212',
                }}
    let(:title) {'nodemanager12c'}
    let(:facts) {{ :operatingsystem => 'CentOS' ,
                   :kernel          => 'Linux',
                   :osfamily        => 'RedHat' }}


    describe "start nodemanager 3" do
      it { 
           should contain_exec("startNodemanager nodemanager12c").with({
             'command'     => 'nohup /opt/oracle/wlsdomains/domains/wls1212/bin/startNodeManager.sh &',
             'cwd'         => '/opt/oracle/wlsdomains/domains/wls1212/nodemanager',
             'user'        => 'oracle',
             'group'       => 'dba',
             'environment' => ["JAVA_OPTIONS=-Dweblogic.ssl.JSSEEnabled=false -Dweblogic.security.SSL.enableJSSE=false ", "JAVA_HOME=/usr/java/jdk1.7.0_45", "JAVA_VENDOR=Oracle"],
           })
         }  
    end

  end  



end
