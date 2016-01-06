path = require 'path'

express = require 'express'

bodyparser = require 'body-parser'
cookieparser = require 'cookie-parser'
methodoverride = require 'method-override'
morgan = require 'morgan'
favicon = require 'serve-favicon'
flash = require 'flash'
passport = require 'passport'
session = require 'express-session'
MongoStore = require('connect-mongo') session
ConnectMincer = require 'connect-mincer'
i18n = require 'i18n'


module.exports = (app, done) ->
  app.disable 'x-powered-by'
  app.locals.pretty = app.env isnt 'production'

  app.set 'views', path.resolve app.root, 'views'
  app.set 'view engine', 'jade'

  app.log "Favicon defined"
  app.use favicon path.resolve app.root, 'public', 'favicon.ico'
  app.log "Public Folder enabled"
  app.use express.static path.resolve(app.root, 'public'),
    redirect: false

  # Assets
  app.log "Assets enabled"
  for p in app.config.assets.middleware.paths
    app.log "Asset Folder #{path.relative app.root, p}"
  connectMincer = new ConnectMincer app.config.assets.middleware
  app.use connectMincer.assets()
  #unless app.env is 'production'
  app.use '/assets', connectMincer.createServer()

  # Parser
  app.use bodyparser.json()
  app.use bodyparser.urlencoded
    extended: true

  app.use cookieparser()

  for getter in app.config.method_overrides.getter
    app.log "Method Override: %j #{getter}", app.config.method_overrides.methods
    app.use methodoverride getter, app.config.method_overrides.methods

  # Session
  sessionConfig =
    cookie:
      maxAge  : 3600000 #new Date Date.now() + 3600000 # 1 Hour
      expires : new Date Date.now() + 3600000 # 1 Hour

  app._.merge sessionConfig,
    app.config.session,
    store: new MongoStore
      db: app.connection.db
      ttl: 14 * 24 * 60 * 60 # = 14 days. Default

  app.use session sessionConfig

  app.use flash()

  app.use passport.initialize()
  app.use passport.session()
  
  app.use i18n.init

  app.use morgan 'dev' if app.env is 'development'
  app.use morgan 'combined' if app.env is 'production'
  done()