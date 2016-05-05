newparam(:remote) do
  include EasyType
  include EasyType::Validators::Name

  desc 'remote option for deployment.'
  newvalues(1, 0)

  defaultto '1'

  to_translate_to_resource do | raw_resource|
    raw_resource['remote']
  end

end
