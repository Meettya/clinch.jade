###
This is separate Jade template for Clinch processor
###
Jade  = require 'jade'
_     = require 'lodash'

extension = '.jade'

JADE_SETTINGS = 
  pretty        : on
  self          : on
  compileDebug  : off

processor = (data, filename, cb) ->
  try
    content = Jade.compileClient data, _.assign {}, JADE_SETTINGS, { filename }
  catch error
    return cb error

  cb null, "module.exports = #{content}"

builder = (options) ->
  extension : extension
  processor : (data, filename, cb) ->
    try
      content = Jade.compileClient data, _.assign {}, JADE_SETTINGS, options, { filename }
    catch error
      return cb error

    cb null, "module.exports = #{content}"

# dirty hack to use as object
builder.extension = extension
builder.processor = processor

module.exports = builder
