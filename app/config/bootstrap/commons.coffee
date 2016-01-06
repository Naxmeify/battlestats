path = require 'path'

module.exports = (app, done) ->
  load = (rel, opts={}) ->
    conf =
      onFileBasename: true
    app._.merge conf, opts
    app.utils.file.loadAndMerge path.resolve(app.root, 'common', rel), conf

  # load common helpers
  app.helpers = load 'helpers',
    onRequire: (fileObj) ->
      require(fileObj.path) app

  # load common policies, models, services and middlewares
  app.policies = load 'policies'
  app.models = load 'models'
  app.services = load 'services'
  app.middlewares = load 'middlewares'

  app.log "Loaded Policies %j", Object.keys app.policies
  app.log "Loaded Models %j", Object.keys app.models
  app.log "Loaded Services %j", Object.keys app.services
  app.log "Loaded Middlewares %j", Object.keys app.middlewares
  app.log "Loaded Helpers %j", Object.keys app.helpers

  # expose common models, policies and services
  app.utils.global.exposeMany app.models, (key) -> app._.capitalize "#{key}"
  app.utils.global.exposeMany app.policies, (key) -> app._.capitalize "#{key}Policy"
  app.utils.global.exposeMany app.services, (key) -> app._.capitalize "#{key}Service"
  
  done()