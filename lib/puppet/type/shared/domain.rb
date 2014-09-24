newparam(:domain) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'Domain name'

  defaultto 'default'

  to_translate_to_resource do | raw_resource|
    raw_resource['domain']
  end

  #
  # Define this Kernel method to make it easy to use this proc in all types
  #
  module Kernel
    def parse_domain_title
      @@proc ||= lambda { |domain_name| domain_name.nil? ? 'default' : domain_name[0..-2] }
    end
  end

end
