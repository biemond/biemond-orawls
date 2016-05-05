newproperty(:log_date_pattern) do
  include EasyType

  desc <<-EOD
  The date format pattern used for rendering dates in the log. 

  The DateFormatPattern string conforms to the specification of the java.text.SimpleDateFormat class.

  EOD

  to_translate_to_resource do |raw_resource|
    raw_resource['log_date_pattern']
  end

end
