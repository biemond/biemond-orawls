require 'puppet/util/log'
# Check if the FMW product is already configured
Puppet::Functions.create_function(:'orawls::product_configured') do

  # Check if the FMW product is already configured
  # @param full_domain_path the full path to the domain
  # @param target the WebLogic artifact it is deployed on
  # @param product the FMW product like SOA, OSB, OIM, BAM
  # @return [Boolean] Return if it is found or not
  # @example Finding a FMW product
  #   orawls::product_configured('/opt/oracle/wlsdomains', 'soa_cluster', 'soa') => true
  dispatch :exists do
    param 'String', :full_domain_path
    param 'String', :target
    param 'String', :product
    # return_type 'Boolean'
  end

  def exists(full_domain_path, target, product)
    art_exists = false
    full_domain_path = full_domain_path.strip.downcase
    target = target.strip.downcase
    product = product.strip.downcase

    log "#{product} full domain path #{full_domain_path}"
    prefix = 'ora_mdw_domain'

    # check the middleware home
    scope = closure_scope
    domain_count = scope['facts'][prefix + '_cnt']
    log "#{product} total domains #{domain_count}"
    if domain_count == 'NotFound'
      log "#{product} no domains found return false"
      return art_exists
    else
      n = 0
      while n < domain_count.to_i

        # lookup up domain
        domain = scope['facts'][prefix + '_' + n.to_s]
        unless domain == 'NotFound'
          domain = domain.strip.downcase
          # do we found the right domain
          log "#{product} compare #{full_domain_path} with #{domain}"

          if domain == full_domain_path
            if product == 'soa'
              type = '_soa'
            elsif product == 'osb'
              type = '_osb'
            elsif product == 'bam'
              type = '_bam'
            elsif product == 'jrf'
              type = '_jrf'
            elsif product == 'oim'
              type = '_oim_configured'
            else
              log "#{product} product not known return false"
              return art_exists
            end                              
            wls_artifact = scope['facts'][prefix + '_' + n.to_s + type]
            log "#{product} target is #{wls_artifact} compare with #{target}"
            unless wls_artifact == 'NotFound'
              wls_artifact = wls_artifact.strip.downcase
              if wls_artifact.include? target
                log "#{product} return true"
                return true
              end
            end
          end

        end
        n += 1
      end
    end
    log "#{product} end of function return false"
    return art_exists

  end

  def log(msg)
    Puppet::Util::Log.create(
      :level   => :info,
      :message => msg,
      :source  => 'orawls::product_configured'
    )
  end

end