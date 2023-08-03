install.packages("RODBC")
library(RODBC);
# Establish database connection

dsn_driver = "{IBM DB2 ODBC Driver}"
dsn_database = "bludb"
dsn_hostname = "764264db-9824-4b7c-82df-40d1b13897c2.bs2io90l08kqb1od8lcg.databases.appdomain.cloud"
dsn_port = "32536"
dsn_protocol = "TCPIP"
dsn_uid = "pdz60743"
dsn_pwd = "Nu4d6XPBBCHkcBFS"
dsn_security = "ssl"

conn_path <- paste("DRIVER=", dsn_driver,
                  ";DATABASE=",dsn_database,
                  ";HOSTNAME=",dsn_hostname,
                  ";PORT=",dsn_port,
                  ";PROTOCOL=",dsn_protocol,
                  ";UID=",dsn_uid,
                  ";PWD=",dsn_pwd,
                  ";SECURITY=",dsn_security,
                        sep="")
conn <- odbcDriverConnect(conn_path)
conn

 sql.info <- sqlTypeInfo(conn)
    conn.info <- odbcGetInfo(conn)
    conn.info["DBMS_Name"]
    conn.info["DBMS_Ver"]
    conn.info["Driver_ODBC_Ver"]
