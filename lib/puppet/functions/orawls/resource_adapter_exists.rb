require 'puppet/util/log'
# Check if the FMW resource adapter/entry is already configured
Puppet::Functions.create_function(:'orawls::resource_adapter_exists') do

  # Check if the FMW resource adapter/entry is already configured
  # @param full_domain_path the full path to the domain
  # @param wls_type the WebLogic artifact type
  # @param adapter_name name of the resource adapter
  # @param adapter_entry entry or plan name
  # @return [Boolean] Return if it is found or not
  # @example Finding a resource entry
  #   orawls::resource_adapter_exists('/opt/oracle/wlsdomains','resource', 'fileAdapter', 'aaaa') => true
  dispatch :exists do
    param 'String', :full_domain_path
    param 'String', :wls_type
    param 'String', :adapter_name
    param 'String', :adapter_entry
    # return_type 'Boolean'
  end

  def exists(full_domain_path, wls_type, adapter_name, adapter_entry)
    art_exists = false
    full_domain_path = full_domain_path.strip.downcase
    wls_type = wls_type.strip
    adapter_name = adapter_name.strip
    adapter_entry = adapter_entry.strip
    prefix = 'ora_mdw_domain'

    # check the middleware home
    scope = closure_scope
    domain_count = scope['facts'][prefix + '_cnt']
    log "#{adapter_name} total domains #{domain_count}"
    if domain_count == 'NotFound'
      log "no domains found return false"
      return art_exists
    else
      n = 0
      while n < domain_count.to_i

        domain = scope['facts'][prefix + '_' + n.to_s]
        unless domain == 'NotFound'
          domain = domain.strip.downcase
          # do we found the right domain
          log "#{adapter_name} compare #{full_domain_path} with #{domain}"
          if domain == full_domain_path

            case wls_type
            when 'resource'
              adapter = adapter_name.downcase
              plan = adapter_entry.downcase

              planValue =  scope['facts'][prefix + '_' + n.to_s + '_eis_' + adapter + '_plan']
              unless planValue == 'NotFound'
                log "#{adapter_name} resource #{planValue} compare with #{plan}"
                return true if planValue.strip.downcase == plan
              end

            when 'resource_entry'
              adapter = adapter_name.downcase
              entry = adapter_entry.strip

              planEntries = scope['facts'][prefix + '_' + n.to_s + '_eis_' + adapter + '_entries']
              unless planEntries == 'NotFound'
                log "#{adapter_name} resource_entry #{planEntries} compare with #{entry}"
                return true if planEntries.include? entry
              end
            end
          end
        end
        n += 1
      end
    end

    log "#{adapter_name} end of function return false"
    return art_exists

  end

  def log(msg)
    Puppet::Util::Log.create(
      :level   => :info,
      :message => msg,
      :source  => 'orawls::resource_adapter_exists'
    )
  end

end