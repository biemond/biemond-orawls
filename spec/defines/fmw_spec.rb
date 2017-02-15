require 'spec_helper'

describe 'orawls::fmw', :type => :define do

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
                  :puppet_download_mnt_point               => '/mnt',
                  :temp_dir             => '/tmp',
                  :log_output           => true,
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

  context 'repuppet_download_mnt_point title needing sanitising' do
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
                  :puppet_download_mnt_point               => '/mnt',
                  :temp_dir             => '/tmp',
                  :log_output           => true,
                }}
    let(:title) {'My Oracle-"SOA" Installation!?'}
    let(:facts) {{ :operatingsystem => 'CentOS' ,
                   :kernel          => 'Linux',
                   :osfamily        => 'RedHat' }}
    it { is_expected.to compile }
    it { is_expected.to contain_file("/install/My_Oracle-SOA_Installation_silent.rsp") }
  end
end
