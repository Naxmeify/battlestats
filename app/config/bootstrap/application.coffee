i18n = require 'i18n'

setupHostConf = (app, done) ->
  if app.config.ip
    app.config.host = "#{app.config.ip}:#{app.config.port}"
  else
    app.config.host = app.config.port

  app.config.protocol = process.env.PROTOCOL or 'http'
  app.config.domain = process.env.DOMAIN or 'localhost:3000'
  app.config.url = "#{app.config.protocol}://#{app.config.domain}"
  
  done()
  
setupI18n = (app, done) ->
  # configure i18n
  console.log Object.keys app.config
  i18n.configure app.config.i18n
  done()
  
module.exports = (app, config, done) ->
  
  # merge configs
  app._.merge app.config, config
  
  app.async.series [
    (next) -> app.config.bootstrap.database app, next
    
    (next) -> setupHostConf app, next
    (next) -> setupI18n app, next
    
    (next) -> app.config.bootstrap.commons app, next
    (next) -> app.config.bootstrap.apps app, next
    (next) -> app.config.bootstrap.assets app, next
    (next) -> app.config.bootstrap.express app, next
    (next) -> app.config.bootstrap.helpers app, next
    (next) -> app.config.bootstrap.middlewares app, next
    (next) -> app.config.bootstrap.seeds app, next
    (next) -> app.config.bootstrap.routes app, next
  ], done