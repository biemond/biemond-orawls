begin
  require 'puppet/util/log'

  module Puppet::Parser::Functions
    newfunction(:jrf_cluster_configured, :type => :rvalue) do |args|

      jrf_exists = false

      if args[0].nil?
        return jrf_exists
      else
        fullDomainPath = args[0].strip.downcase
      end
      log "jrf_cluster_configured fullDomainPath is #{fullDomainPath}"

      if args[1].nil?
        return jrf_exists
      else
        target = args[1].strip.downcase
      end
      log "jrf_cluster_configured target is #{target}"

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
          log "jrf_cluster_configured found domain is #{domain}"
          unless domain == 'empty'
            domain = domain.strip.downcase
            # do we found the right domain
            log "jrf_cluster_configured compare domain #{domain} with #{fullDomainPath}"
            if domain == fullDomainPath
              jrf =  lookup_wls_var(prefix + '_' + n.to_s + '_jrf')
              log "jrf_cluster_configured jrf target is #{jrf}"
              unless jrf == 'empty'
                jrf = jrf.strip.downcase
                if jrf.include? target
                  log 'jrf_cluster_configured return true'
                  return true
                end
              end
            end
          end
          n += 1
        end
      end

      return jrf_exists
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
      :source  => 'jrf_cluster_configured'
    )
  end

end
