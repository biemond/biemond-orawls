begin
  require 'puppet/util/log'

  module Puppet::Parser::Functions
    newfunction(:osb_cluster_configured, :type => :rvalue) do |args|

      osb_exists = false

      if args[0].nil?
        return osb_exists
      else
        fullDomainPath = args[0].strip.downcase
      end
      log "osb_cluster_configured fullDomainPath is #{fullDomainPath}"

      if args[1].nil?
        return osb_exists
      else
        target = args[1].strip.downcase
      end
      log "osb_cluster_configured target is #{target}"

      prefix = 'ora_mdw_domain'

      # check the middleware home
      domain_count = lookup_wls_var(prefix + '_cnt')
      if domain_count == 'empty'
        return art_exists
      else
        n = 0
        while n < domain_count.to_i

          # lookup up domain
          domain = lookup_wls_var(prefix + '_' + n.to_s)
          log "osb_cluster_configured found domain is #{domain}"
          unless domain == 'empty'
            domain = domain.strip.downcase
            # do we found the right domain
            log "osb_cluster_configured compare domain #{domain} with #{fullDomainPath}"
            if domain == fullDomainPath
              osb =  lookup_wls_var(prefix + '_' + n.to_s + '_osb')
              log "osb_cluster_configured osb target is #{osb}"
              unless osb == 'empty'
                osb = osb.strip.downcase
                if osb.include? target
                  log 'osb_cluster_configured return true'
                  return true
                end
              end
            end
          end
          n += 1
        end
      end

      return osb_exists
    end
  end

  def lookup_wls_var(name)
    if wls_var_exists(name)
      return lookupvar(name).to_s
    end
    'empty'
  end

  def wls_var_exists(name)
    if lookupvar(name) != :undefined
      if lookupvar(name).nil?
        return false
      end
      return true
    end
    false
  end

  def log(msg)
    Puppet::Util::Log.create(
      :level   => :info,
      :message => msg,
      :source  => 'osb_cluster_configured'
    )
  end

end
