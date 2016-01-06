http = require 'http'
path = require 'path'

express = require 'express'
lodash = require 'lodash'
async = require 'async'
debug = require 'debug'

utils = require 'sonea-utils'
manifest = require '../package.json'

app = express()
app.server = http.createServer app

app.env = app.get 'env'
app.utils = utils
app.utils.app = require './utils/app'

app.manifest = manifest
app.root = global.ROOT = __dirname

app._ = lodash
app.async = async

app.log = debug 'battlestats'

app.env = app.get 'env'

app.isBootstrapped = false
app.bootstrap = (config={}, done=config) ->
  app.log "Bootstrap Application"
  config = {} if app._.isFunction config
  
  app.config = app.utils.file.loadAndMerge path.resolve app.root, 'config'
  
  app.config.bootstrap = app.utils.file.loadAndMerge path.resolve(app.root, 'config', 'bootstrap'),
    onFileBasename: true
  
  app.config.bootstrap.application app, config, (err) ->
    app.isBootstrapped = true unless err
    done err

app.start = (config={}, done=(->)) ->
  app.bootstrap config, (err) ->
    return done err if err
    app.log "Start Application"
    app.server.listen app.config.port, app.config.ip, done

app.stop = (done=(->)) ->
  app.log "Stop Application"
  app.server.close done

module.exports = app
