require 'spec_helper'
require 'puppet'
require 'puppet/type/wls_deployment'

describe Puppet::Type.type(:wls_deployment) do

  before :each do
    @deployment = Puppet::Type.type(:wls_deployment).new({:name => 'testdeployment', :localpath => '/an/absolute/path'})
  end

  describe 'localpath' do
    it 'should accept an absolute path for localpath' do
      expect(@deployment[:localpath]).to eq('/an/absolute/path')
    end

    it 'should fail if localpath isn\'t an absolute path' do
      expect {
        Puppet::Type.type(:wls_deployment).new({:name => 'testdeployment', :localpath => 'not_an_absolute_path'})
      }.to raise_error(/not_an_absolute_path is not an absolute path/)
    end

    it 'should fail if localpath is in /tmp' do
      expect {
        Puppet::Type.type(:wls_deployment).new({:name => 'testdeployment', :localpath => '/tmp/app.war'})
      }.to raise_error(/localpath can not be in \/tmp/)
    end

  end
end
