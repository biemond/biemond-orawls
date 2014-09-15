require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_saf_imported_destination_object).provide(:simple) do
  include EasyType::Provider

  desc 'saf imported destination Queue or Topic in a JMS module of an WebLogic domain via regular WLST'
  mk_resource_methods
end
