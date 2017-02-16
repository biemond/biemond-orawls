require 'spec_helper'

describe 'orawls::bsu', :type => :define do

  describe 'unix' do 
    let :pre_condition do
      'class { "orawls::weblogic":
         version                   => 1111,
         filename                  => "wls1036_generic.jar",
         oracle_base_home_dir      => "opt/oracle",
         middleware_home_dir       => "opt/oracle/middleware11gR1",
         weblogic_home_dir         => "/opt/oracle/middleware11gR1/wlserver_103",
         jdk_home_dir              => "/usr/java/jdk1.7.0_45",
         download_dir              => "/install",
         puppet_download_mnt_point => "/software",
         remote_file               => false,
       }'
    end


    describe "CentOS remote" do
      let(:params){{:ensure               => 'present',
                    :download_dir         => '/install',
                    :os_user              => 'oracle',
                    :os_group             => 'dba',
                    :middleware_home_dir  => '/opt/oracle/middleware11gR1',
                    :weblogic_home_dir    => '/opt/oracle/middleware11gR1/wlserver_103',
                    :jdk_home_dir         => '/usr/java/jdk1.7.0_45',
                    :remote_file          => true,
                    :patch_id             => 'FCX7',
                    :patch_file           => 'p17572726_1036_Generic.zip',
                    :puppet_download_mnt_point => 'puppet:///middleware',
                  }}
      let(:title) {'/opt/oracle/middleware11gR1:FCX7'}
      let(:facts) {{ :operatingsystem => 'CentOS' ,
                     :kernel          => 'Linux',
                     :osfamily        => 'RedHat' }}

      describe "cache dir creation" do
        it do
          should contain_file("/opt/oracle/middleware11gR1/utils/bsu/cache_dir")
        end
      end

      describe "download patch" do
        it {
             should contain_file("/install/p17572726_1036_Generic.zip").with({
               'source'  => 'puppet:///middleware/p17572726_1036_Generic.zip',
             }).that_comes_before('Exec[extract p17572726_1036_Generic.zip]')
           }
      end

      describe "extract patch" do
        it {
             should contain_exec("extract p17572726_1036_Generic.zip").with({
               'command'  => 'unzip -o /install/p17572726_1036_Generic.zip -d /opt/oracle/middleware11gR1/utils/bsu/cache_dir',
             }).that_comes_before('Bsu_patch[/opt/oracle/middleware11gR1:FCX7]')
           }
      end

      describe "install BSU" do
        it {
             should contain_bsu_patch("/opt/oracle/middleware11gR1:FCX7").with({
               'ensure'               => 'present',
               'middleware_home_dir'  => '/opt/oracle/middleware11gR1',
               'os_user'              => 'oracle',
               'weblogic_home_dir'    => '/opt/oracle/middleware11gR1/wlserver_103',
               'jdk_home_dir'         => '/usr/java/jdk1.7.0_45',
             })
          }
      end
    end

    describe "CentOS local" do
      let(:params){{:ensure               => 'present',
                    :download_dir         => '/install',
                    :os_user              => 'oracle',
                    :os_group             => 'dba',
                    :middleware_home_dir  => '/opt/oracle/middleware11gR1',
                    :weblogic_home_dir    => '/opt/oracle/middleware11gR1/wlserver_103',
                    :jdk_home_dir         => '/usr/java/jdk1.7.0_45',
                    :remote_file          => false,
                    :patch_id             => 'FCX7',
                    :patch_file           => 'p17572726_1036_Generic.zip',
                    :puppet_download_mnt_point => '/mnt',
                  }}
      let(:title) {'/opt/oracle/middleware11gR1:FCX7'}
      let(:facts) {{ :operatingsystem => 'CentOS' ,
                     :kernel          => 'Linux',
                     :osfamily        => 'RedHat' }}

      describe "cache dir creation" do
        it do
          should contain_file("/opt/oracle/middleware11gR1/utils/bsu/cache_dir")
        end
      end

      describe "extract patch" do
        it {
             should contain_exec("extract p17572726_1036_Generic.zip").with({
               'command'  => 'unzip -o /mnt/p17572726_1036_Generic.zip -d /opt/oracle/middleware11gR1/utils/bsu/cache_dir',
             }).that_comes_before('Bsu_patch[/opt/oracle/middleware11gR1:FCX7]')
           }
      end

      describe "install BSU" do
        it {
             should contain_bsu_patch("/opt/oracle/middleware11gR1:FCX7").with({
               'ensure'               => 'present',
               'middleware_home_dir'  => '/opt/oracle/middleware11gR1',
               'os_user'              => 'oracle',
               'weblogic_home_dir'    => '/opt/oracle/middleware11gR1/wlserver_103',
               'jdk_home_dir'         => '/usr/java/jdk1.7.0_45',
             })
          }
      end
    end
  end

end
