require 'pathname'
#$:.unshift(Pathname.new(__FILE__).dirname)
#$:.unshift(Pathname.new(__FILE__).dirname.parent.parent + 'easy_type' + 'lib')
$:.unshift File.dirname(__FILE__)
$:.unshift File.join(File.dirname(__FILE__), '../../easy_type/lib')
require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'utils/title_parser'
require 'facter'

