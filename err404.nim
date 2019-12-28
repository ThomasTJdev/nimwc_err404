
import ../../nimwcpkg/plugins/plugins

when defined(postgres): import db_postgres
else: import db_sqlite

import logging
from strutils import replace

include "html.nimf"


proc pluginInfo() =
  let (n, v, d, u) = pluginGetDetails("err404")
  echo " "
  echo "--------------------------------------------"
  echo "  Package:      " & n
  echo "  Version:      " & v
  echo "  Description:  " & d
  echo "  URL:          " & u
  echo "--------------------------------------------"
  echo " "
pluginInfo()


proc err404Start*(db: DbConn): auto =
  info("err404 plugin: Updating database with err404 table if not exists")

  if not db.tryExec(sql"""
  create table if not exists err404_settings (
    id INTEGER primary key,
    errmsg TEXT
  );""", []):
    info("err404 plugin: err404 table created in database")

  if getValue(db, sql("SELECT errmsg FROM err404_settings;")) == "":
    exec(db, sql("INSERT INTO err404_settings (errmsg) VALUES (?);"), "<h1>[[errmsg]]</h1><p>You should go <a href='/'>back</a>.")