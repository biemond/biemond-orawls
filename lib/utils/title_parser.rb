module Utils
  module TitleParser

    def parse_domain_title
      @@domain_parser ||= lambda { |domain_name| domain_name.nil? ? 'default' : domain_name[0..-2]}
    end

    def parse_name
      @@name_parser ||= lambda { |name|name.include?('/') ? name : "default/#{name}"}
    end

    def add_title_attributes(*attributes, &proc)
      base_attributes = [:name, parse_name] , [:domain, parse_domain_title]
      all_attributes = base_attributes + attributes
      map_title_to_attributes(*all_attributes, &proc)
    end
  end
end
