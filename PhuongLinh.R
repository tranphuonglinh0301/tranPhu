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
# CROP_DATA:
tables <- "CROP_DATA"

    for (table in tables) {
        # Drop tables if they already exist
        out <- sqlTables(conn, tableType = "TABLE",
                          tableName = table)
        if (nrow(out)>0) {
            err <- sqlDrop(conn, table,
                            errors=FALSE)  
            if (err==-1) {
                cat("An error has occurred.\n")
                err.msg <- odbcGetErrMsg(conn)
                for (error in err.msg) { 
                    cat(error,"\n")
                }
            } 
            else {
                cat ("Table: ",table," was dropped\n")
            }
        }
        else {
              cat ("Table: ", table," does not exist\n")
        }
    }
df1 <- sqlQuery (conn, 
                 "CREATE TABLE CROP_DATA (
                    CD_ID INTEGER NOT NULL,
                    YEAR DATE NOT NULL,
                    CROP_TYPE VARCHAR(20) NOT NULL,
                    GEO VARCHAR(20) NOT NULL,
                    SEEDED_AREA INTEGER NOT NULL,
                    HARVESTED_AREA INTEGER NOT NULL,
                    PRODUCTION INTEGER NOT NULL,
                    AVG_YIELD INTEGER NOT NULL,
                    PRIMARY KEY (CD_ID)
                    )", errors=FALSE)
 if (df1 == -1){
        cat ("An error has occurred.\n")
        msg <- odbcGetErrMsg(conn)
        print (msg)
    } else {
        cat ("Table was created successfully.\n")
    }               
# FARM_PRICES:

tables <- "FARM_PRICES"

    for (table in tables) {
        # Drop tables if they already exist
        out <- sqlTables(conn, tableType = "TABLE",
                          tableName = table)
        if (nrow(out)>0) {
            err <- sqlDrop(conn, table,
                            errors=FALSE)  
            if (err==-1) {
                cat("An error has occurred.\n")
                err.msg <- odbcGetErrMsg(conn)
                for (error in err.msg) { 
                    cat(error,"\n")
                }
            } 
            else {
                cat ("Table: ",table," was dropped\n")
            }
        }
        else {
              cat ("Table: ", table," does not exist\n")
        }
    }
df2 <- sqlQuery (conn, 
                 "CREATE TABLE FARM_PRICES (
                    CD_ID INTEGER NOT NULL,
                    DATE DATE NOT NULL,
                    CROP_TYPE VARCHAR(20) NOT NULL,
                    GEO VARCHAR(20) NOT NULL,
                    PRICE_PRERMT FLOAT(6) NOT NULL,
                    FOREIGN KEY (CD_ID) REFERENCES CROP_DATA(CD_ID)
                    )", errors=FALSE)
 if (df2 == -1){
        cat ("An error has occurred.\n")
        msg <- odbcGetErrMsg(conn)
        print (msg)
    } else {
        cat ("Table was created successfully.\n")
    }            
# DAILY_FX:
tables <- "DAILY_FX"

    for (table in tables) {
        # Drop tables if they already exist
        out <- sqlTables(conn, tableType = "TABLE",
                          tableName = table)
        if (nrow(out)>0) {
            err <- sqlDrop(conn, table,
                            errors=FALSE)  
            if (err==-1) {
                cat("An error has occurred.\n")
                err.msg <- odbcGetErrMsg(conn)
                for (error in err.msg) { 
                    cat(error,"\n")
                }
            } 
            else {
                cat ("Table: ",table," was dropped\n")
            }
        }
        else {
              cat ("Table: ", table," does not exist\n")
        }
    }
df3 <- sqlQuery (conn, 
                 "CREATE TABLE DAILY_FX (
                    DFX_ID INTEGER NOT NULL,
                    DATE DATE NOT NULL,
                    FXUSDCAD FLOAT(6) NOT NULL,
                    PRIMARY KEY (DFX_ID)
                    )", errors=FALSE)
 if (df3 == -1){
        cat ("An error has occurred.\n")
        msg <- odbcGetErrMsg(conn)
        print (msg)
    } else {
        cat ("Table was created successfully.\n")
    }       
# MONTHLY_FX:
tables <- "MONTHLY_FX"

    for (table in tables) {
        # Drop tables if they already exist
        out <- sqlTables(conn, tableType = "TABLE",
                          tableName = table)
        if (nrow(out)>0) {
            err <- sqlDrop(conn, table,
                            errors=FALSE)  
            if (err==-1) {
                cat("An error has occurred.\n")
                err.msg <- odbcGetErrMsg(conn)
                for (error in err.msg) { 
                    cat(error,"\n")
                }
            } 
            else {
                cat ("Table: ",table," was dropped\n")
            }
        }
        else {
              cat ("Table: ", table," does not exist\n")
        }
    }
df4 <- sqlQuery (conn, 
                 "CREATE TABLE MONTHLY_FX (
                    DFX_ID INTEGER NOT NULL,
                    DATE DATE NOT NULL,
                    FXUSDCAD FLOAT(6) NOT NULL,
                    FOREIGN KEY (DFX_ID) REFERENCES DAILY_FX(DFX_ID)
                    )", errors=FALSE)
 if (df4 == -1){
        cat ("An error has occurred.\n")
        msg <- odbcGetErrMsg(conn)
        print (msg)
    } else {
        cat ("Table was created successfully.\n")
    }       
df1 <- read.csv("https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-RP0203EN-SkillsNetwork/labs/Final%20Project/Annual_Crop_Data.csv",colClasses = c(YEAR = "character"))
df2 <- read.csv("https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-RP0203EN-SkillsNetwork/labs/Final%20Project/Monthly_Farm_Prices.csv",colClasses = c(DATE = "character"))
df3 <- read.csv("https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-RP0203EN-SkillsNetwork/labs/Final%20Project/Daily_FX.csv",colClasses = c(DATE = "character"))
df4 <- read.csv("https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-RP0203EN-SkillsNetwork/labs/Final%20Project/Monthly_FX.csv",colClasses = c(DATE = "character"))
head(df1)
head(df2)
head(df3)
head(df4)
sqlSave(conn, df1, "CROP_DATA", append=TRUE, fast=FALSE, rownames=FALSE, colnames=FALSE, verbose=FALSE)
sqlSave(conn, df2, "FARM_PRICES", append=TRUE, fast=FALSE, rownames=FALSE, colnames=FALSE, verbose=FALSE)
sqlSave(conn, df3, "MONTHLY_FX", append=TRUE, fast=FALSE, rownames=FALSE, colnames=FALSE, verbose=FALSE)
sqlSave(conn, df4, "DAILY_FX", append=TRUE, fast=FALSE, rownames=FALSE, colnames=FALSE, verbose=FALSE)
