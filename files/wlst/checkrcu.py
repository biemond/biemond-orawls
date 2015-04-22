from java.sql import DriverManager

jdbcurl  = sys.argv[1]
password = sys.argv[2]
prefix   = sys.argv[3]
sysuser  = sys.argv[4]

conn = DriverManager.getConnection(jdbcurl, sysuser + " as sysdba", password)
stmt = conn.createStatement()
try:
    rs = stmt.executeQuery("select distinct 'found' from system.schema_version_registry where upper(mrc_name) = upper('"+prefix+"')")

    while rs.next():
      print rs.getString(1)

    rs.close()
    stmt.close()
    conn.close()

except:
    print "rcu table does not exists"
    stmt.close()
    conn.close()
