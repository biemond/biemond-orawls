newparam(:coherence_cluster_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'The coherence cluster name'

end
