module.exports = (app, done) ->
  # load custom middlewares
  for key, middleware of app.middlewares
    app.use middleware
    app.log "Load and using '#{key}' middleware"
    
  done()