newproperty(:datasourceforjobscheduler) do
  include EasyType
  include EasyType::Validators::Name

  desc "The DataSource For JobScheduler which are part of this cluster"

  to_translate_to_resource do | raw_resource|
    raw_resource['datasourceforjobscheduler']
  end

end

