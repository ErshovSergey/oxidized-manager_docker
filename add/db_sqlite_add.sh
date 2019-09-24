#/bin/bash
sqlite3=`which sqlite3`
DB_FILE=/home/oxidized/oxidized-manager/router.db
SQLITE_OPTIONS=" -column -header "
 

$sqlite3 $DB_FILE "create table IF NOT EXISTS devices (
fqdn TEXT, model TEXT, username TEXT, password TEXT, enable TEXT
                   );"
#                               address TEXT,
#                               type TEXT,
#                               username TEXT,
#                               password TEXT
#      group TEXT,
#      name TEXT,
#      ip TEXT,
#      model TEXT,
#      ssh_port TEXT,
#      ssh_proxy TEXT,
#      username TEXT,
#      password TEXT


$sqlite3 $DB_FILE  " insert into devices (fqdn, model, username, password, enable) values  ('1.1.1.1', 'routeros', 'admin', 'admin', '1')"
       

#$sqlite3 $DB_FILE  " insert into devices (address,type,username,password) values  ('1.1.1.1', 'routeros', 'admin', 'admin')"
#$sqlite3 $DB_FILE  " insert into devices (      group,
#      name,
#      ip,
#      model,
#      ssh_port,
#      ssh_proxy,
#      username,
#      password
#) values  ('qwe', 'asd','1.1.1.1', 'routeros', '23', '1.1.1.1', 'admin', 'admin')"



