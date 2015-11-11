require 'easy_type/helpers'
require 'fileutils'
require File.dirname(__FILE__) + '/../../../orawls_core'
require 'utils/indent'

Puppet::Type.type(:wls_exec).provide(:sqlplus) do
  include EasyType::Helpers
  include EasyType::Template
  include Utils::WlsAccess

  mk_resource_methods

  def flush
    return if resource[:refreshonly] == :true
    execute
  end

  def execute
    domain     = resource[:domain]
    cwd        = resource[:cwd]
    statement  = resource[:statement]
    #
    # If the statement start's with a @, it is a script. The content will be executed
    #
    if is_script?(statement)
      file_name = statement.split('@').last
      fail "File #{file_name} doesn't exist. " unless File.exists?(file_name)
      statement = File.read(file_name)
    end
    statement = statement.indent(2)

    fail "Working directory '#{cwd}' does not exist" if cwd && !File.directory?(cwd)
    FileUtils.cd(resource[:cwd]) if resource[:cwd]
    environment = { 'action' => 'execute', 'type' => 'wls_exec' }
    output = wlst template('puppet:///modules/orawls/providers/wls_exec/execute.py.erb', binding), environment
    Puppet.debug(output) if resource.logoutput == :true
  end

  private

  def is_script?(statement)
    statement.chars.first == '@'
  end

end
