# Authenticate
setAccountInfo(name = Sys.getenv("blitzthegap"),
               token = Sys.getenv("TOKEN"),
               secret = Sys.getenv("SECRET"))
# Deploy
deployApp(appFiles = c("app.R"))
