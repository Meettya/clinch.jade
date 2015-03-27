
chai = require 'chai'
path  = require 'path'
util = require 'util'

###
global helper for chai.should()
###
GLOBAL.should = chai.should()
GLOBAL.expect = chai.expect # to work with 'undefined' - should cant it

###
addon for lib_path
###
lib_dir = 'lib'
GLOBAL.lib_path = path.join '..', lib_dir

###
just helper
###
GLOBAL.inspect = (item) ->
  util.inspect item, true, null, true