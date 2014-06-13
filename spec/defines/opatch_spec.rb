require 'spec_helper'

describe 'orawls::opatch', :type => :define do

  describe "CentOS remote" do
    let(:params){{:ensure                   => 'present',
                  :download_dir             => '/install',
                  :os_user                  => 'oracle',
                  :os_group                 => 'dba',
                  :oracle_product_home_dir  => '/opt/oracle/middleware11g/Oracle_SOA1',
                  :jdk_home_dir             => '/usr/java/jdk1.7.0_45',
                  :remote_file              => true,
                  :patch_id                 => '17584181',
                  :patch_file               => 'p17584181_111170_Generic.zip',
                  :source                   => 'puppet:///middleware',
                }}
    let(:title) {'17584181'}
    let(:facts) {{ :operatingsystem => 'CentOS' ,
                   :kernel          => 'Linux',
                   :osfamily        => 'RedHat' }}

    describe "download patch" do
      it { 
           should contain_file("/install/p17584181_111170_Generic.zip").with({
             'source'  => 'puppet:///middleware/p17584181_111170_Generic.zip',
           }).that_comes_before('Exec[extract opatch p17584181_111170_Generic.zip 17584181]')  
         }  
    end

    describe "extract patch" do
      it { 
           should contain_exec("extract opatch p17584181_111170_Generic.zip 17584181").with({
             'command'  => 'unzip -n /install/p17584181_111170_Generic.zip -d /install',
           }).that_comes_before('Opatch[17584181]')  
         }  
    end

    describe "install OPatch" do
      it { 
           should contain_opatch("17584181").with({
             'ensure'                   => 'present',
             'oracle_product_home_dir'  => '/opt/oracle/middleware11g/Oracle_SOA1',
             'os_user'                  => 'oracle',
             'orainst_dir'              => '/etc',
             'jdk_home_dir'             => '/usr/java/jdk1.7.0_45',
             'extracted_patch_dir'      => "/install/17584181",

           })
        }  
    end
  end

  describe "CentOS local" do
    let(:params){{:ensure                   => 'present',
                  :download_dir             => '/install',
                  :os_user                  => 'oracle',
                  :os_group                 => 'dba',
                  :oracle_product_home_dir  => '/opt/oracle/middleware11g/Oracle_SOA1',
                  :jdk_home_dir             => '/usr/java/jdk1.7.0_45',
                  :remote_file              => false,
                  :patch_id                 => '17584181',
                  :patch_file               => 'p17584181_111170_Generic.zip',
                  :source                   => '/mnt',
                }}
    let(:title) {'17584181'}
    let(:facts) {{ :operatingsystem => 'CentOS' ,
                   :kernel          => 'Linux',
                   :osfamily        => 'RedHat' }}

    describe "extract patch" do
      it { 
           should contain_exec("extract opatch p17584181_111170_Generic.zip 17584181").with({
             'command'  => 'unzip -n /mnt/p17584181_111170_Generic.zip -d /install',
           }).that_comes_before('Opatch[17584181]')  
         }  
    end

    describe "install OPatch" do
      it { 
           should contain_opatch("17584181").with({
             'ensure'                   => 'present',
             'oracle_product_home_dir'  => '/opt/oracle/middleware11g/Oracle_SOA1',
             'os_user'                  => 'oracle',
             'orainst_dir'              => '/etc',
             'jdk_home_dir'             => '/usr/java/jdk1.7.0_45',
             'extracted_patch_dir'      => "/install/17584181",

           })
        }  
    end
  end


end
