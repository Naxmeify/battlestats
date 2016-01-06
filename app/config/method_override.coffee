_ = require 'lodash'

module.exports.method_overrides =
  methods: [
    'DELETE'
  ]
  getter: [
    '_method'
    (req, res) ->
      if req.body and _.isObject(req.body) and '_method' in req.body
        # look in urlencoded POST bodies and delete it
        method = req.body._method
        delete req.body._method
        return method
  ]