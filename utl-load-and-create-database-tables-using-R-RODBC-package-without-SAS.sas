Load and create database tables using R RODBC package without SAS

* Because accdb layout changes it is better to use an existing accdb or mdb
  SAS ships with sample MS Access mdb and accdb databases;

https://tinyurl.com/yy86zl47
https://github.com/rogerjdeangelis/utl-load-and-create-database-tables-using-R-RODBC-package-without-SAS

SAS Forum
https://tinyurl.com/y5loffmr
https://communities.sas.com/t5/SAS-Enterprise-Guide/SAS-connection-through-ODBC/m-p/534072?nobounce

for more odbc examples;
https://tinyurl.com/y8f5yczs
https://github.com/rogerjdeangelis/utl_creating_sas7bdat_from_32bit_or_64bit_ms-access_table_using_wps_express_proc_R

https://tinyurl.com/y75f7ypv
https://github.com/rogerjdeangelis/utl-unix-or-windows-export-dataset-to-ms-access-mdb-without-sas-access

https://tinyurl.com/y6xr7reg
https://github.com/rogerjdeangelis/utl_exporting_longtext_fields_to_ms_access


INPUT  (copy SAS shipped MS access databases)
=============================================

data _null_;
call system('copy C:\Progra~1\sashome\sasfou~1\9.4\access\sasmisc\demo~1.acc d:\mdb\demo.accdb');
call system('copy C:\Progra~1\sashome\sasfou~1\9.4\access\sasmisc\demo.mdb d:\mdb\demo.mdb');
run;quit;

EXAMPLE OUTPUT
--------------

Up to 40 obs from CUST total obs=20

Obs    CUSTOMER    STATE    ZIP_CODE    COUNTRY                 PHONE

  1    14324742     CA        95123     USA                     408/629-0589
  2    14569877     NC        27514     USA                     919/489-6792
  3    14898029     MD        20850     USA                     301/760-2541
  4    15432147     MI        49001     USA                     616/582-3906
  5    18543489     TX        78701     USA                     512/478-0788
  6    19783482     VA        22090     USA                     703/714-2900
  7    19876078     CA        93274     USA                     209/686-3953
  8    26422096               75014     France                  4268-54-72
  9    26984578                5110     Austria                 43-57-04
 10    27654351                5010     Belgium                 02/215-37-32
 11    28710427     HV         3607     Netherlands             (021)570517
 12    29834248                   .     Britain                 (0552)715311
 13    31548901     BC            .     Canada                  406/422-3413
 14    38763919                1405     Argentina               244-6324
 15    39045213     SP         1051     Brazil                  012/302-1021
 16    43290587                   .     Japan                   (02)933-3212
 17    43459747                3181     Australia               03/734-5111
 18    46543295                   .     Japan                   (03)022-2332
 19    46783280                2374     Singapore               3762855
 20    48345514                   .     United Arab Emirates    213445


PROCESS
=======

%utl_submit_r64('
library(RODBC);
library(SASxport);
myDB<-odbcDriverConnect("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=d:/mdb/demo.accdb");
customers<-sqlQuery(myDB, paste("select * from customers"));
cust<-as.data.frame(lapply(customers,function(x) if(is.factor(x)) as.character(x) else x), stringsAsFactors=FALSE);
write.xport(cust,file="d:/xpt/cust.xpt");
');

libname xpt xport "d:/xpt/cust.xpt";

data cust;
  set xpt.cust;
run;quit;

libname xpt clear;



