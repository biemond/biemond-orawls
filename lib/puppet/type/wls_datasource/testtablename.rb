newproperty(:testtablename) do
  include EasyType

  desc "The test table statement for the datasource"

  to_translate_to_resource do | raw_resource|
    raw_resource['testtablename']
  end

end