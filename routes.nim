
  get "/err404/settings":
    createTFD()
    resp genMain(c, gen404Settings(db))

  post "/err404/update":
    createTFD()
    if not c.loggedIn or c.rank notin [Admin]:
      redirect("/")

    exec(db, sql("UPDATE err404_settings SET errmsg = ?;"), @"errmsg")

    redirect("/err404/settings")

  # Error codes
  error {Http401 .. Http408}:
    createTFD()
    if error.data.code == Http401:
      pass
    doAssert error.data.code != Http401

    resp error.data.code, genMain(c, gen404(db, $error.data.code))