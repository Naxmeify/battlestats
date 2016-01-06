module.exports = (app, done) ->
  assetPaths = app.utils.app.assetPaths app.root
  for assetPath in assetPaths
    app.config.assets.middleware.paths.push assetPath
        
  for key, subapp of app.apps
    for assetPath in subapp.assetPaths
      app.config.assets.middleware.paths.push assetPath
  
  done()