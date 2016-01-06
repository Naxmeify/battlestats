path = require 'path'

express = require 'express'
debug = require 'debug'
_ = require 'lodash'

log = debug 'battlestats:utils:express'

fileUtils = require('sonea-utils').file
appUtils = require './app'

module.exports.loadExpressApp = (target, parent) ->
  app = express()
  app.root = target
  app.set 'name', "#{path.basename target}"

  app.log = debug "battlestats:#{app.get 'name'}"
  app.log "Init #{app.get 'name'}"

  app.parent = parent
  app.utils = parent.utils

  app.config = fileUtils.loadAndMerge path.resolve app.root, 'config'
  app.assetPaths = appUtils.assetPaths target
  appChecks = appUtils.checkPath target

  for key, check of appChecks
    if check
      app[key] = fileUtils.loadAndMerge path.resolve(app.root, key),
        onFileBasename: true
      app.log "Load #{key} #{Object.keys app[key]}"

  _.merge app.locals, app.helpers if app.helpers

  app.env = app.get 'env'

  app.disable 'x-powered-by'
  app.locals.pretty = app.env isnt 'production'

  app.set 'views', path.resolve app.root, 'views'
  app.set 'view engine', 'jade'

  return app
