newparam(:class_name) do
    include EasyType

    desc 'The fully qualified classname of the singleton service'

    to_translate_to_resource do | raw_resource|
        raw_resource['class_name']
    end
end
