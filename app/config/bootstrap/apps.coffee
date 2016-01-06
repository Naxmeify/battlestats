path = require 'path'

module.exports = (app, done) ->
  app.apps = {}
  expressApps = app.utils.file.loadAndMerge path.resolve(app.root, 'apps'),
    matcher: (fileObj) ->
      return fileObj.stats.isDirectory()
    onFileBasename: true
    onRequire: (fileObj) ->
      return app.utils.express.loadExpressApp fileObj.path, app

  appBootstrapper = []
  for key, expressApp of expressApps
    if expressApp.config.bootstrap and app._.isFunction expressApp.config.bootstrap
      appBootstrapper.push do (expressApp) ->
        (next) -> expressApp.config.bootstrap expressApp, next
    if expressApp.config.routes and app._.isFunction expressApp.config.routes
      app.apps[expressApp.get 'name'] = expressApp
      appBootstrapper.push do (expressApp) ->
        (next) -> expressApp.config.routes expressApp, next
    else
      app.log "Express App \"#{expressApp.get 'name'}\" not loaded. No routes config found."

  app.async.series appBootstrapper, (err) ->
    app.log "Loaded Apps %j", Object.keys app.apps unless err
    done err