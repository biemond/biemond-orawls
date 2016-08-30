require 'spec_helper'

describe 'orawls::weblogic', :type => :class do

  describe "wrong weblogic version" do
    let(:params){{
                  :version              => 1000,
                  :download_dir         => '/install',
                  :filename             => 'wls1036_generic.jar',
                  :os_user              => 'oracle',
                  :os_group             => 'dba',
                  :middleware_home_dir  => '/opt/oracle/middleware11gR1',
                  :oracle_base_home_dir => '/opt/oracle',
                  :jdk_home_dir         => '/usr/java/jdk1.7.0_45',
                }}
    let(:facts) {{ :operatingsystem => 'CentOS' ,
                   :kernel          => 'Linux',
                   :osfamily        => 'RedHat' }}

    it do
      expect { should contain_file("/install/weblogic_silent_install.xml")
             }.to raise_error(Puppet::Error, /unknown weblogic version parameter/)
    end

  end

  describe "required parameters" do
    let(:params){{
                    :version              => 1036,
                    :download_dir         => '/install',
                }}
    let(:facts) {{ :operatingsystem => 'CentOS' ,
                   :kernel          => 'Linux',
                   :osfamily        => 'RedHat' }}

    it do
      expect { should contain_file("/install/weblogic_silent_install.xml")
             }.to raise_error(Puppet::Error, /please provide all the required parameters/)
    end

  end

  describe "wrong OS" do
    let(:params){{
                  :version              => 1036,
                  :download_dir         => '/install',
                  :filename             => 'wls1036_generic.jar',
                  :os_user              => 'oracle',
                  :os_group             => 'dba',
                  :middleware_home_dir  => '/opt/oracle/middleware11gR1',
                  :oracle_base_home_dir => '/opt/oracle',
                  :jdk_home_dir         => '/usr/java/jdk1.7.0_45',
                }}
    let(:facts) {{ :operatingsystem => 'Windows' ,
                   :kernel          => 'Windows',
                   :osfamily        => 'Windows' }}

    it do
      expect { should contain_file("/install/weblogic_silent_install.xml")
             }.to raise_error(Puppet::Error, /Unrecognized operating system Windows, please use it on a Linux host/)
    end

  end

end
