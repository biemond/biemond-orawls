newparam(:action) do
  include EasyType

  desc 'action to apply authorization policy on for a queue or topic'

  newvalues(:send, :receive, :browse, :all)

  to_translate_to_resource do | raw_resource |
    raw_resource['action']
  end

end
