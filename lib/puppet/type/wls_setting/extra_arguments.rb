newproperty(:extra_arguments) do
  include EasyType

  desc 'extra arguments passed on to the wls deamon'

  to_translate_to_resource do | raw_resource|
    raw_resource[self.name]
  end

end
