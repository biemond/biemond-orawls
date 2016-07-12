require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_opatch).provide(:prefetching) do
  include EasyType::Provider

  desc 'Apply Oracle OPatches'

  mk_resource_methods

  def self.prefetch(resources)
    os_user = check_single_os_user(resources)
    orainst_dir = check_single_orainst_dir(resources)

    all_patches = oracle_homes(resources).collect {|h| patches_in_home(h, os_user, orainst_dir)}.flatten
    resources.keys.each do |patch_name|
      if all_patches.include?(patch_name)
        resources[patch_name].provider = new(:name => name, :ensure => :present)
      end
    end
  end

  def opatch(command)
    kernel = Facter.value(:kernel)
    su_shell = kernel == 'Linux' ? '-s /bin/bash' : ''
    oracle_product_home_dir = resource[:oracle_product_home_dir]
    jre_specfied            = resource[:jdk_home_dir] ? " -jre #{resource[:jdk_home_dir]} " : ''
    orainst                 = "-invPtrLoc #{resource[:orainst_dir]}/oraInst.loc "
    os_user                 = resource[:os_user]
    full_command            = "export ORACLE_HOME=#{oracle_product_home_dir};#{oracle_product_home_dir}/OPatch/opatch #{command} -oh #{oracle_product_home_dir} #{jre_specfied} #{orainst}"
    if Puppet.features.root?
      output = `su #{su_shell} - #{os_user} -c 'ORACLE_HOME=#{oracle_product_home_dir};#{oracle_product_home_dir}/OPatch/opatch #{command} -oh #{oracle_product_home_dir} #{jre_specfied} #{orainst}'`
    else
      output = `export ORACLE_HOME=#{oracle_product_home_dir};#{oracle_product_home_dir}/OPatch/opatch #{command} -oh #{oracle_product_home_dir} #{jre_specfied} #{orainst}`
    end
    Puppet.info output
    output
  end

  private

  def installed_patches
    opatch('lsinventory').scan(/Patch\s.(\d+)\s.*:\sapplied on/).flatten
  end

  def self.patches_in_home(oracle_product_home_dir, os_user, orainst_dir)
    kernel = Facter.value(:kernel)
    su_shell = kernel == 'Linux' ? '-s /bin/bash' : ''
    full_command  = "#{oracle_product_home_dir}/OPatch/opatch lsinventory -oh #{oracle_product_home_dir} -invPtrLoc #{orainst_dir}/oraInst.loc"
    if Puppet.features.root?
      raw_list = `su #{su_shell} - #{os_user} -c '#{oracle_product_home_dir}/OPatch/opatch lsinventory -oh #{oracle_product_home_dir} -invPtrLoc #{orainst_dir}/oraInst.loc'`
    else
      raw_list = `#{oracle_product_home_dir}/OPatch/opatch lsinventory -oh #{oracle_product_home_dir} -invPtrLoc #{orainst_dir}/oraInst.loc`
    end
    Puppet.info raw_list
    patch_ids = raw_list.scan(/Patch\s.(\d+)\s.*:\sapplied on/).flatten
    patch_ids.collect{|p| "#{oracle_product_home_dir}:#{p}"}
  end

  def self.check_single_os_user(resources)
    os_users = resources.map{|k,v| v.os_user}.uniq
    fail "wls_opatch doesn't support multiple os_users" if os_users.size > 1
    os_users.first
  end

  def self.check_single_orainst_dir(resources)
    orainst_dir = resources.map{|k,v| v.orainst_dir}.uniq
    fail "wls_opatch doesn't support multiple orainst_dir" if orainst_dir.size > 1
    orainst_dir.first
  end

  def self.oracle_homes(resources)
    resources.map{|k,v| v.oracle_product_home_dir}.uniq
  end

end