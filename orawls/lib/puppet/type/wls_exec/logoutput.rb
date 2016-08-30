newparam(:logoutput) do
  desc <<-EOD
  Whether to log command output in addition to logging the
  exit code.  Defaults to `on_failure`, which only logs the output
  when the command has an exit code that does not match any value
  specified by the `returns` attribute. As with any resource type,
  the log level can be controlled with the `loglevel` metaparameter."
  EOD

  defaultto :on_failure

  newvalues(:true, :false, :on_failure)
end
