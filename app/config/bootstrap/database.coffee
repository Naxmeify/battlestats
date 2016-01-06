mongoose = require 'mongoose'
require 'mongoose-schema-extend'
autoIncrement = require 'mongoose-auto-increment'

module.exports = (app, done) ->
  app.log "Try to connect to MongoDB #{app.config.database.uri}"
  mongoose.connect app.config.database.uri,
    app.config.database.options, (err) ->
      unless err
        app.log "MongoDB Connected"
        app.connection = mongoose.connection
        autoIncrement.initialize app.connection
      done err