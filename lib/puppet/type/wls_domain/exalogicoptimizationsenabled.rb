newproperty(:exalogicoptimizationsenabled) do
  include EasyType
  
  desc 'Enable or disabled exalogic optimizations'
  
  to_translate_to_resource do | raw_resource|
    raw_resource['exalogicoptimizationsenabled']
  end

end
