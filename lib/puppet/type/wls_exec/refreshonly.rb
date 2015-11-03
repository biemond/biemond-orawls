newparam(:refreshonly) do
  desc <<-'EOT'
    The command should only be run as a
    refresh mechanism for when a dependent object is changed.  It only
    makes sense to use this option when this command depends on some
    other object; it is useful for triggering an action:

    Note that only `subscribe` and `notify` can trigger actions, not `require`,
    so it only makes sense to use `refreshonly` with `subscribe` or `notify`.
  EOT

  newvalues(:true, :false)

end
