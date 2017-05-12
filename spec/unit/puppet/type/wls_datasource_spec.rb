require 'spec_helper'

describe Puppet::Type.type(:wls_datasource) do
  describe 'when validating attributes' do
    [ :domain, :name, :datasource_name, :provider ].each do |param|
      it "should have a #{param} parameter" do
        expect(described_class.attrtype(param)).to eq(:param)
      end
    end
    [ :ensure,
      :connectioncreationretryfrequency,
      :drivername,
      :datasourcetype,
      :fanenabled,
      :globaltransactionsprotocol,
      :initialcapacity,
      :initsql,
      :jndinames,
      :maxcapacity,
      :mincapacity,
      :password,
      :removeinfectedconnections,
      :rowprefetchenabled,
      :rowprefetchsize,
      :secondstotrustidlepoolconnection,
      :shrinkfrequencyseconds,
      :statementcachetype,
      :statementcachesize,
      :target,
      :targettype,
      :testconnectionsonreserve,
      :testfrequency,
      :testtablename,
      :url,
      :user,
      :usexa,
      :wrapdatatypes,
      :xaproperties].each do |prop|
      it "should have a #{prop} property" do
        expect(described_class.attrtype(prop)).to eq(:property)
      end
    end
  end
  describe 'when validating attribute values' do
    describe 'removeinfectedconnections' do
      it 'should accept booleans' do
        expect { @ds = described_class.new( {:title => 'resourcetitle', :removeinfectedconnections => true})}.to_not raise_error
        expect { @ds = described_class.new( {:title => 'resourcetitle', :removeinfectedconnections => false})}.to_not raise_error
      end
      it 'should munge \'0\' to :false' do
        @ds = described_class.new( {:title => 'resourcetitle', :removeinfectedconnections => '0'})
        expect(@ds[:removeinfectedconnections]).to eq(:false)
      end
      it 'should munge \'1\' to :true' do
        @ds = described_class.new( {:title => 'resourcetitle', :removeinfectedconnections => '1'})
        expect(@ds[:removeinfectedconnections]).to eq(:true)
      end
    end
  end
end
