path = require 'path'

module.exports.assets =
  middleware:
    root: path.resolve(__dirname, '..')
    production: false #process.env.NODE_ENV is 'production'
    mountPoint: '/assets'
    manifestFile: path.resolve(__dirname, '..', 'public/assets/manifest.json')
    paths: []

  precompiler:
    files: [
      'error.css'

      '*.eot'
      '*.svg'
      '*.ttf'
      '*.woff'
      '*.woff2'
      '*.png'
      '*.gif'
      '*.jpg'
      '*.ico'

      '**/*.eot'
      '**/*.svg'
      '**/*.ttf'
      '**/*.woff'
      '**/*.woff2'
      '**/*.png'
      '**/*.gif'
      '**/*.jpg'
      '**/*.ico'
    ]