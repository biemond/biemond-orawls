require 'spec_helper'

describe 'orawls::ohs::forwarder', :type => :define do
  let(:title) {'default'}

  describe 'call with param servers empty should fail' do
    let(:params) {{:owner        => 'oracle',
                   :group        => 'oracle',
                   :default_port => '7001',
                   :servers      => [],
                   :domain_path  => '/opt/test/wls/domains/domain1',
                   :location     => '/console',
    }}

    it {
      should raise_error(Puppet::Error, /servers can't be empty/)
    }
  end

  describe 'with one host, default port' do
    let(:params) {{:owner        => 'oracle',
                   :group        => 'oracle',
                   :default_port => '7001',
                   :servers      => ['192.168.1.1'],
                   :domain_path  => '/opt/test/wls/domains/domain1',
                   :location     => '/console',
    }}

    it {
      should contain_file('/opt/test/wls/domains/domain1/config/fmwconfig/components/OHS/ohs1/mod_wl_ohs.d/default.conf').with({
        'ensure'  => 'present',
        'owner'   => 'oracle',
        'group'   => 'oracle',
      })
      .with_content(/\<LocationMatch "\/console"\>/)
      .with_content(/WebLogicHost 192.168.1.1/)
      .with_content(/WebLogicPort 7001/)
    }
  end

  describe 'with one host, custom port' do
    let(:params) {{:owner       => 'oracle',
                   :group       => 'oracle',
                   :servers     => ['192.168.1.1:7002'],
                   :domain_path => '/opt/test/wls/domains/domain1',
                   :location    => '/console',
    }}

    it {
      should contain_file('/opt/test/wls/domains/domain1/config/fmwconfig/components/OHS/ohs1/mod_wl_ohs.d/default.conf').with({
        'ensure'  => 'present',
        'owner'   => 'oracle',
        'group'   => 'oracle',
      })
      .with_content(/\<LocationMatch "\/console"\>/)
      .with_content(/WebLogicHost 192.168.1.1/)
      .with_content(/WebLogicPort 7002/)
    }
  end

  describe 'with two hosts, default ports' do
    let(:params) {{:owner       => 'oracle',
                   :group       => 'oracle',
                   :servers     => ['192.168.1.1', '192.168.1.2'],
                   :domain_path => '/opt/test/wls/domains/domain1',
                   :location    => '/console',
    }}

    it {
      should contain_file('/opt/test/wls/domains/domain1/config/fmwconfig/components/OHS/ohs1/mod_wl_ohs.d/default.conf').with({
        'ensure'  => 'present',
        'owner'   => 'oracle',
        'group'   => 'oracle',
      })
      .with_content(/\<LocationMatch "\/console"\>/)
      .with_content(/WebLogicCluster 192.168.1.1:7001,192.168.1.2:7001/)
    }
  end

  describe 'with two hosts, one with custom port' do
    let(:params) {{:owner        => 'oracle',
                   :group        => 'oracle',
                   :servers      => ['192.168.1.1:7003', '192.168.1.2'],
                   :domain_path  => '/opt/test/wls/domains/domain1',
                   :location     => '/console',
    }}

    it {
      should contain_file('/opt/test/wls/domains/domain1/config/fmwconfig/components/OHS/ohs1/mod_wl_ohs.d/default.conf').with({
        'ensure'  => 'present',
        'owner'   => 'oracle',
        'group'   => 'oracle',
      })
      .with_content(/\<LocationMatch "\/console"\>/)
      .with_content(/WebLogicCluster 192.168.1.1:7003,192.168.1.2:7001/)
    }
  end

  describe 'with two hosts, both with custom ports' do
    let(:params) {{:owner        => 'oracle',
                   :group        => 'oracle',
                   :servers      => ['192.168.1.1:7003', '192.168.1.2:7004'],
                   :domain_path  => '/opt/test/wls/domains/domain1',
                   :location     => '/console',
    }}

    it {
      should contain_file('/opt/test/wls/domains/domain1/config/fmwconfig/components/OHS/ohs1/mod_wl_ohs.d/default.conf').with({
        'ensure'  => 'present',
        'owner'   => 'oracle',
        'group'   => 'oracle',
      })
      .with_content(/\<LocationMatch "\/console"\>/)
      .with_content(/WebLogicCluster 192.168.1.1:7003,192.168.1.2:7004/)
    }
  end
end