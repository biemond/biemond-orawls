begin
  require 'puppet/util/log'

  module Puppet
    module Parser
      module Functions
        newfunction(:bam_cluster_configured, :type => :rvalue) do |args|

          bam_exists = false

          if args[0].nil?
            return bam_exists
          else
            fullDomainPath = args[0].strip.downcase
          end
          log "bam_cluster_configured fullDomainPath is #{fullDomainPath}"

          if args[1].nil?
            return bam_exists
          else
            target = args[1].strip.downcase
          end
          log "bam_cluster_configured target is #{target}"

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
              log "bam_cluster_configured found domain is #{domain}"

              unless domain == 'empty'
                domain = domain.strip.downcase
                # do we found the right domain
                log "bam_cluster_configured compare domain #{domain} with #{fullDomainPath}"
                if domain == fullDomainPath
                  bam =  lookup_wls_var(prefix + '_' + n.to_s + '_bam')
                  log "bam_cluster_configured bam target is #{bam}"
                  unless bam == 'empty'
                    bam = bam.strip.downcase
                    if bam.include? target
                      log 'bam_cluster_configured return true'
                      return true
                    end
                  end
                end
              end
              n += 1
            end
          end

          return bam_exists
        end
      end
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
      :source  => 'bam_cluster_configured'
    )
  end

end
