require 'utils/indent'

newproperty(:statement) do
  include Utils::WlsAccess
  include ::EasyType::Helpers
  include ::EasyType::Template

  desc "The wlst statement or script to execute"

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
    if is_script?(statement)
      file_name = statement.split('@').last
      fail "File #{file_name} doesn't exist. " unless File.exists?(file_name)
      statement = File.read(file_name)
    end
    statement = statement.indent(2)  # Make sure the script has 2 spaces indenting
    environment = { 'action' => 'index', 'type' => 'wls_exec' }
    output = wlst template('puppet:///modules/orawls/providers/wls_exec/execute.py.erb', binding), environment
    !output.empty?
  end

  def is_script?(statement)
    statement.chars.first == '@'
  end

end
