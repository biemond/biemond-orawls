newparam(:cluster) do
    include EasyType

    desc 'The cluster this singleton service should be targetted to'

    to_translate_to_resource do | raw_resource|
        raw_resource['cluster']
    end
end
