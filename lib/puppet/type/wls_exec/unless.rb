
newparam(:unless) do

  desc <<-EOD
  A statement to determine if the wls_exec must execute or not.

  If the statement returns something,the wls_exec is **NOT** executed. If the statement returns nothing,
  the specified wls_exec statement **IS** executed.

  The unless clause **must** be a valid WLST statement. An error in the query will result in
  a failure of the apply statement.

  EOD

end
