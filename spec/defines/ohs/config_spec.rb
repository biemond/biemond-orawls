require 'spec_helper'

describe 'orawls::ohs::config', :type => :define do
  let(:title) {'default'}

  describe 'with one location' do
    let(:params) {{:server_name => 'ohs1',
                   :domain_path => '/opt/test/wls/domains/domain1',
                   :owner       => 'oracle',
                   :group       => 'oracle',
                   :locations   => {'/console' => ['192.168.1.1:7001']},
                 }}
    it {
      should contain_file('/opt/test/wls/domains/domain1/config/fmwconfig/components/OHS/instances/ohs1/mod_wl_ohs.d').with({
        'ensure' => 'directory',
        'owner'  => 'oracle',
        'group'  => 'oracle',
      })

      should contain_file('/opt/test/wls/domains/domain1/config/fmwconfig/components/OHS/instances/ohs1/mod_wl_ohs.conf').with({
        'ensure' => 'present',
        'owner'  => 'oracle',
        'group'  => 'oracle',
      })

      should contain_file('/opt/test/wls/domains/domain1/config/fmwconfig/components/OHS/instances/ohs1/mod_wl_ohs.d/default.conf').with({
        'ensure'  => 'present',
        'owner'   => 'oracle',
        'group'   => 'oracle',
      })
      .with_content(/\<LocationMatch "\/console"\>/)
      .with_content(/WebLogicHost 192.168.1.1/)
      .with_content(/WebLogicPort 7001/)
      .that_requires('File[/opt/test/wls/domains/domain1/config/fmwconfig/components/OHS/instances/ohs1/mod_wl_ohs.d]')
    }
  end

  describe 'with two locations' do
    let(:params) {{:server_name => 'ohs1',
                   :domain_path => '/opt/test/wls/domains/domain1',
                   :owner       => 'oracle',
                   :group       => 'oracle',
                   :locations   => {
                      '/console'     => ['192.168.1.1:7001'],
                      '/application' => ['192.168.1.2:7001', '192.168.1.3:7001'],
                    },
                 }}
    it {
      should contain_file('/opt/test/wls/domains/domain1/config/fmwconfig/components/OHS/instances/ohs1/mod_wl_ohs.d/default.conf').with({
        'ensure'  => 'present',
        'owner'   => 'oracle',
        'group'   => 'oracle',
      })
      .with_content(/\<LocationMatch "\/console"\>/)
      .with_content(/WebLogicHost 192.168.1.1/)
      .with_content(/WebLogicPort 7001/)
      .with_content(/\<LocationMatch "\/application"\>/)
      .with_content(/WebLogicCluster 192.168.1.2:7001,192.168.1.3:7001/)
      .that_requires('File[/opt/test/wls/domains/domain1/config/fmwconfig/components/OHS/instances/ohs1/mod_wl_ohs.d]')
    }
  end
end