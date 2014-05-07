require 'spec_helper'

describe 'orawls::fmw', :type => :define do

  describe "CentOS remote" do
  	let(:params){{:download_dir         => '/install',
  		          :fmw_product          => 'soa',
  		          :os_user              => 'oracle',
  		          :os_group             => 'dba',
  		          :middleware_home_dir  => '/opt/oracle/middleware11gR1',
                  :weblogic_home_dir    => '/opt/oracle/middleware11gR1/wlserver_103',
                  :oracle_base_home_dir => '/opt/oracle', 
  		          :remote_file          => true,
                  :jdk_home_dir         => '/usr/java/jdk1.7.0_45',
                  :fmw_file1            => 'file1',
                  :fmw_file2            => 'file2',
                  :source               => '/mnt',
  		          }}
    let(:title) {'soaPS6'}
    let(:facts) {{ :operatingsystem => 'CentOS' ,
                   :kernel          => 'Linux',
                   :osfamily        => 'RedHat' }}

    describe "oracle product should not exists" do
      it do 
        should contain_notify("orawls::fmw soaPS6 /opt/oracle/middleware11gR1/Oracle_SOA1 does not exists")
      end
    end

    describe "SOA Suite orainst" do
      it do 
        should contain_orawls__utils__orainst('create oraInst for soa').with({
             'ora_inventory_dir'  => '/opt/oracle/oraInventory',
             'os_group'           => 'dba',
           })
      end
    end


    describe "for SOA Suite response file" do
      it do 
        should contain_file("/install/soaPS6_silent_soa.rsp")
      end
    end

    describe "for SOA Suite file1" do
      it { 
           should contain_file("/install/file1").with({
             'source'  => '/mnt/file1',
           }).that_comes_before('Exec[extract file1]')  
         }  
    end

    describe "extract SOA Suite file1" do
      it { 
           should contain_exec("extract file1").with({
             'command'  => 'unzip -o /install/file1 -d /install/soa',
             'creates'  => '/install/soa/Disk1',
           }).that_requires('Orawls::Utils::Orainst[create oraInst for soa]')  
         }  
    end

    describe "for SOA Suite file2" do
      it do 
        should contain_file("/install/file2").with({
             'source'  => '/mnt/file2',
           }).that_comes_before('Exec[extract file2]')  
      end
    end

    describe "extract SOA Suite file2" do
      it { 
           should contain_exec("extract file2").with({
             'command'  => 'unzip -o /install/file2 -d /install/soa',
             'creates'  => '/install/soa/Disk4',
           }).that_requires('Exec[extract file1]').that_comes_before('Exec[install soa soaPS6]')   
         }  
    end


    describe "create Oracle home" do
      it do 
        should contain_file("/opt/oracle/middleware11gR1/Oracle_SOA1").with({
             'ensure'  => 'directory',
          }).that_comes_before('Exec[install soa soaPS6]')   
      end
    end

    describe "install SOA Suite" do
      it { 
           should contain_exec("install soa soaPS6").with({
             'command'      => '/install/soa/Disk1/install/linux64/runInstaller -silent -response /install/soaPS6_silent_soa.rsp -waitforcompletion -invPtrLoc /etc/oraInst.loc -ignoreSysPrereqs -jreLoc /usr/java/jdk1.7.0_45 -Djava.io.tmpdir=/tmp',
             'environment'  => 'TMP=/tmp',
           }).that_requires('File[/install/soaPS6_silent_soa.rsp]').that_requires('Orawls::Utils::Orainst[create oraInst for soa]').that_requires('Exec[extract file1]')     
         }  
    end

  end

  describe "CentOS local" do
  	let(:params){{:download_dir         => '/install',
  		          :fmw_product          => 'osb',
  		          :os_user              => 'oracle',
  		          :os_group             => 'dba',
  		          :middleware_home_dir  => '/opt/oracle/middleware11gR1',
                  :weblogic_home_dir    => '/opt/oracle/middleware11gR1/wlserver_103',
                  :oracle_base_home_dir => '/opt/oracle', 
  		          :remote_file          => false,
                  :jdk_home_dir         => '/usr/java/jdk1.7.0_45',
                  :fmw_file1            => 'file1',
                  :fmw_file2            => 'file2',
                  :source               => '/mnt',
                  :temp_directory       => '/tmp1',
  		          }}
    let(:title) {'osbPS6'}
    let(:facts) {{ :operatingsystem => 'CentOS' ,
                   :kernel          => 'Linux',
                   :osfamily        => 'RedHat',
                   :architecture    => 'i386',}}

    describe "oracle product should not exists" do
      it do 
        should contain_notify("orawls::fmw osbPS6 /opt/oracle/middleware11gR1/Oracle_OSB1 does not exists")
      end
    end

    describe "OSB orainst" do
      it do 
        should contain_orawls__utils__orainst('create oraInst for osb').with({
             'ora_inventory_dir'  => '/opt/oracle/oraInventory',
             'os_group'           => 'dba',
           })
      end
    end


    describe "for OSB response file" do
      it do 
        should contain_file("/install/osbPS6_silent_osb.rsp")
      end
    end

    describe "extract OSB file1" do
      it { 
           should contain_exec("extract file1").with({
             'command'  => 'unzip -o /mnt/file1 -d /install/osb',
             'creates'  => '/install/osb/Disk1',
           }).that_requires('Orawls::Utils::Orainst[create oraInst for osb]')  
         }  
    end

    describe "create Oracle home" do
      it do 
        should contain_file("/opt/oracle/middleware11gR1/Oracle_OSB1").with({
             'ensure'  => 'directory',
          }).that_comes_before('Exec[install osb osbPS6]')   
      end
    end

    describe "install OSB" do
      it { 
           should contain_exec("install osb osbPS6").with({
             'command'      => '/install/osb/Disk1/install/linux/runInstaller -silent -response /install/osbPS6_silent_osb.rsp -waitforcompletion -invPtrLoc /etc/oraInst.loc -ignoreSysPrereqs -jreLoc /usr/java/jdk1.7.0_45 -Djava.io.tmpdir=/tmp1',
             'environment'  => 'TMP=/tmp1',
           }).that_requires('File[/install/osbPS6_silent_osb.rsp]').that_requires('Orawls::Utils::Orainst[create oraInst for osb]').that_requires('Exec[extract file1]')     
         }  
    end

  end

end
