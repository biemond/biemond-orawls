require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_opatch).provide(:prefetching) do
  include EasyType::Provider

  include EasyType::Provider

  desc 'Apply Oracle OPatches'

  mk_resource_methods

  def self.prefetch(resources)
    os_user = check_single_os_user(resources)
    all_patches = oracle_homes(resources).collect {|h| patches_in_home(h, os_user)}.flatten
    resources.keys.each do |patch_name| 
      if all_patches.include?(patch_name)
        resources[patch_name].provider = new(:name => name, :ensure => :present)
      end
    end
  end

  def opatch(command)
    oracle_product_home_dir = resource[:oracle_product_home_dir]
    jre_specfied            = resource[:jdk_home_dir] ? " -jre #{resource[:jdk_home_dir]} " : ''
    orainst_specified       = resource[:orainst_dir] ? " -invPtrLoc #{resource[:orainst_dir]} " : ''
    os_user                 = resource[:os_user]
    full_command            = "#{oracle_product_home_dir}/OPatch/opatch #{command} -oh #{oracle_product_home_dir} #{jre_specfied} #{orainst_specified}"
    output = Puppet::Util::Execution.execute(full_command, :failonfail => true, :uid => os_user)
    Puppet.debug output
    output
  end

  private

  def installed_patches
    opatch('lsinventory').scan(/Patch\s.(\d+)\s.*:\sapplied on/).flatten
  end

  def self.patches_in_home(oracle_product_home_dir, os_user)
    full_command  = "#{oracle_product_home_dir}/OPatch/opatch lsinventory -oh #{oracle_product_home_dir}"
    raw_list = Puppet::Util::Execution.execute(full_command, :failonfail => true, :uid => os_user)
    Puppet.debug raw_list 
    patch_ids = raw_list.scan(/Patch\s.(\d+)\s.*:\sapplied on/).flatten
    patch_ids.collect{|p| "#{oracle_product_home_dir}:#{p}"}
  end

  def self.check_single_os_user(resources)
    os_users = resources.map{|k,v| v.os_user}.uniq
    fail "wls_opatch doesn't support multiple os_users" if os_users.size > 1
    os_users.first
  end

  def self.oracle_homes(resources)
    resources.map{|k,v| v.oracle_product_home_dir}.uniq
  end

end

