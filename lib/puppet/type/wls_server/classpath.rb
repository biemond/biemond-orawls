newproperty(:classpath) do
  include EasyType

  desc "The classpath (path on the machine running Node Manager) to use when starting this server.
At a minimum you will need to specify the following values for the class path option: WL_HOME/server/lib/weblogic_sp.jar;WL_HOME/server/lib/weblogic.jar
where WL_HOME is the directory in which you installed WebLogic Server on the Node Manager machine.
The shell environment determines which character you use to separate path elements. On Windows, you typically use a semicolon (;). In a BASH shell, you typically use a colon (:)."
  
  to_translate_to_resource do | raw_resource|
    raw_resource['classpath']
  end

end
