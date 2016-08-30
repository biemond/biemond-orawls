require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_jms_sort_destination_key).provide(:simple) do
  include EasyType::Provider

  desc 'Manage the jms sort destination key object in  WebLogic domain via regular WLST'
  mk_resource_methods
end
