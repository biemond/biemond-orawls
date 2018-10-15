newproperty(:tmp_path) do
  include EasyType

  desc 'the tmp path for WLST output scripts'

  defaultto '/tmp'

  to_translate_to_resource do | raw_resource|
    raw_resource[self.name]
  end

end
