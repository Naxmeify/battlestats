module.exports = (app, done) ->
  # merge helpers
  app.use (req, res, next) ->
    app._.merge res.locals, app.helpers if app.helpers
    next()
    
  done()