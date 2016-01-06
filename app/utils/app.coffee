path = require 'path'
log = require('debug') 'battlestats:utils:app'
fileUtils = require('sonea-utils').file

module.exports.checkPath = (target) ->
  pathsToCheck =
    # assets: false
    controllers: false
    # config: false
    helpers: false
    models: false
    policies: false
    services: false
    # views: false

  # will return objects with false values or paths
  for key, value of pathsToCheck
    pathToCheck = path.resolve target, key
    pathsToCheck[key] = pathToCheck if fileUtils.checkPath pathToCheck

  return pathsToCheck

module.exports.assetPaths = (target) ->
  assetPath = path.resolve target, 'assets'
  assetPaths = []
  if fileUtils.checkPath assetPath
    log "Found Assets Folder"
    paths = fileUtils.findInPath assetPath,
      matcher: (fileObj) -> return fileObj.stats.isDirectory()

    for key, o of paths
      assetPaths.push key
  
  return assetPaths