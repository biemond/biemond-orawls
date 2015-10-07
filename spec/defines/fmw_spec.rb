require 'spec_helper'

describe 'orawls::fmw', :type => :define do

  describe "Windows" do
    let(:params){{:version              => 1111,
                  :download_dir         => '/install',
                  :fmw_product          => 'xxx',
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
                  :temp_directory       => '/tmp',
                }}
    let(:title) {'test'}
    let(:facts) {{ :kernel          => 'Windows',
                   :operatingsystem => 'Windows'}}
    it do
      expect { should contain_file("/install/test_silent_dummy.rsp")
             }.to raise_error(Puppet::Error, /Unrecognized operating system Windows, please use it on a Linux host/)
    end       
  end

  describe "unknown product" do
    let(:params){{:version              => 1111,
                  :download_dir         => '/install',
                  :fmw_product          => 'xxx',
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
                  :temp_directory       => '/tmp',
                }}
    let(:title) {'test'}
    let(:facts) {{ :operatingsystem => 'CentOS' ,
                   :kernel          => 'Linux',
                   :osfamily        => 'RedHat' }}
    it do
      expect { should contain_file("/install/test_silent_dummy.rsp")
             }.to raise_error(Puppet::Error, /unknown fmw_product value choose adf|soa|osb|oim|wc|wcc/)
    end       
  end

  context 'resource title needing sanitising' do
    let(:params){{:version              => 1111,
                  :download_dir         => '/install',
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
                  :temp_directory       => '/tmp',
                }}
    let(:title) {'My Oracle-"SOA" Installation!?'}
    let(:facts) {{ :operatingsystem => 'CentOS' ,
                   :kernel          => 'Linux',
                   :osfamily        => 'RedHat' }}
    it { is_expected.to compile }
    it { is_expected.to contain_file("/install/My_Oracle-SOA_Installation_silent_soa.rsp") }
  end
end
