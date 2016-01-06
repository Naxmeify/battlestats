path = require 'path'

module.exports.i18n = 
  updateFiles: process.env.NODE_ENV isnt 'production'
  directory: path.resolve __dirname, '..', 'locales'
  locales: [
    'de'
  ]
  defaultLocale: 'de'
  cookie: 'battlestats.i18n'
  extension: '.json'