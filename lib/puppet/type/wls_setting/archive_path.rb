newproperty(:archive_path) do
  include EasyType

  desc 'the archive path for WLST scripts we want to keep'

  defaultto '/tmp/orawls-archive'

  to_translate_to_resource do | raw_resource|
    raw_resource[self.name]
  end

end
