require 'spec_helper'

describe 'orawls::urandomfix' , :type => :class do


  it { should contain_package('rng-tools').with_ensure('present') }

  describe "Windows" do
    let(:facts) {{ :kernel          => 'Windows',
                   :operatingsystem => 'Windows',
                   :osfamily        => 'Windows'}}
    it do
      expect { should contain_exec("set urandom /etc/sysconfig/rngd")
             }.to raise_error(Puppet::Error, /Unrecognized osfamily Windows, please use it on a Linux host/)
    end
  end
  describe "SunOS" do
    let(:facts) {{ :kernel          => 'SunOS',
                   :operatingsystem => 'Solaris',
                   :osfamily        => 'Solaris'}}
    it do
      expect { should contain_exec("set urandom /etc/sysconfig/rngd")
             }.to raise_error(Puppet::Error, /Unrecognized osfamily Solaris, please use it on a Linux host/)
    end
  end

  describe "CentOS" do
    let(:facts) {{ :operatingsystem => 'CentOS' ,
                   :kernel          => 'Linux',
                   :osfamily        => 'RedHat' }}

    describe "on operatingsystem CentOS" do
      it do
        should contain_exec("set urandom /etc/sysconfig/rngd").with({
            'user'  => 'root',
          })
      end
      it do
        should contain_service("rngd").with({
            'ensure'     => 'running',
            'enable'     => true,
          })
      end
      it do
        should contain_exec("chkconfig rngd").with({
            'user'    => 'root',
            'command' => "chkconfig --add rngd",
          })
      end
    end

  end
  describe "RedHat" do
    let(:facts) {{ :operatingsystem => 'RedHat' ,
                   :kernel          => 'Linux',
                   :osfamily        => 'RedHat' }}

    describe "on operatingsystem RedHat" do
      it do
        should contain_exec("set urandom /etc/sysconfig/rngd").with({
            'user'  => 'root',
          })
      end
      it do
        should contain_service("rngd").with({
            'ensure'     => 'running',
            'enable'     => true,
          })
      end
      it do
        should contain_exec("chkconfig rngd").with({
            'user'    => 'root',
            'command' => "chkconfig --add rngd",
          })
      end
    end

  end
  describe "OracleLinux" do
    let(:facts) {{ :operatingsystem => 'OracleLinux' ,
                   :kernel          => 'Linux',
                   :osfamily        => 'RedHat' }}

    describe "on operatingsystem OracleLinux" do
      it do
        should contain_exec("set urandom /etc/sysconfig/rngd").with({
            'user'  => 'root',
          })
      end
      it do
        should contain_service("rngd").with({
            'ensure'     => 'running',
            'enable'     => true,
          })
      end
      it do
        should contain_exec("chkconfig rngd").with({
            'user'    => 'root',
            'command' => "chkconfig --add rngd",
          })
      end
    end

  end

  ['Ubuntu','Debian','SLES'].each do |system|
    let(:facts) {{ :operatingsystem => system ,
                   :kernel          => 'Linux',
                   :osfamily        => 'Debian' }}

    describe "on operatingsystem #{system}" do
      it do
        should contain_exec("set urandom /etc/default/rng-tools").with({
            'user'  => 'root',
          })
      end
      it do
        should contain_service("rng-tools").with({
            'ensure'     => 'running',
            'enable'     => true,
          })
      end
    end
  end

end
