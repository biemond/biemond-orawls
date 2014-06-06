newproperty(:post_classpath) do
  include EasyType

  desc "the post classpath"

  to_translate_to_resource do | raw_resource|
    raw_resource[self.name]
  end

end
