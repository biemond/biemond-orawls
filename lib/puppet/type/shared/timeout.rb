newparam(:timeout) do
  include EasyType
  include EasyType::Mungers::Integer

  desc 'Timeout for this operation'

end
