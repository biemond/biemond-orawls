newproperty(:statement) do
  include Utils::WlsAccess
  include ::EasyType::Helpers
  include ::EasyType::Template

  desc 'The wlst statement or script to execute'

  #
  # Let the insync? check for the parameter unless and the refreshonly
  #
  def insync?(to)
    if resource[:refreshonly] != :true
      resource[:unless] ? unless_value? : false
    else
      true
    end
  end

  private

  def unless_value?
    domain = resource[:domain]
    statement = resource[:unless]
    cwd        = resource[:cwd]
    #
    # First fo to the specified working dirctory if specified
    #
    fail "Working directory '#{cwd}' does not exist" if cwd && !File.directory?(cwd)
    FileUtils.cd(resource[:cwd]) if resource[:cwd]
    if is_script?(statement)
      file_name = statement.split('@').last
      fail "File #{file_name} doesn't exist. " unless File.exists?(file_name)
      statement = File.read(file_name)
    end
    statement = statement.indent(4)
    environment = { 'action' => 'execute', 'type' => 'wls_exec' }
    output = wlst template('puppet:///modules/orawls/providers/wls_exec/execute.py.erb', binding), environment
    !output.empty?
  end

  def is_script?(statement)
    statement.chars.first == '@'
  end
end
