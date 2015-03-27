###
Test suite for addon
###
_     = require 'lodash'
fs    = require 'fs'
path  = require 'path'
vm    = require 'vm'

lib_path = GLOBAL?.lib_path || ''

fixtures       = path.join __dirname, "fixtures"
fixturesOk     = path.join fixtures,  "template.jade"
fixturesErr    = path.join fixtures,  "with_error.jade"

results = 
  ok : '<div class="message"><p>Hello Bender!!!</p></div>'
  ok_beauty : '\n<div class="message">\n  <p>Hello Bender!!!</p>\n</div>'

# get addon
adon_file  = 'addon'
addon_path = path.join lib_path, adon_file
Compiller  = require addon_path

READ_OPTIONS = encoding : 'utf8'

describe 'Addon:', ->

  describe 'called without options', ->

    it 'should export "extension" and "processor"', ->
      expect(Compiller).to.have.all.keys ['extension', 'processor']

    it 'should export string as "extension"', ->
      expect(Compiller.extension).to.be.a 'string'

    it 'should export function as "processor"', ->
      expect(Compiller.processor).to.be.a 'function'

  describe 'called with options', ->

    it 'should export "extension" and "processor"', ->
      expect(Compiller compileDebug: yes).to.have.all.keys ['extension', 'processor']

    it 'should export string as "extension"', ->
      expect(Compiller(compileDebug: yes).extension).to.be.a 'string'

    it 'should export function as "processor"', ->
      expect(Compiller(compileDebug: yes).processor).to.be.a 'function'

  describe 'as addon', ->

    it 'should export correct file extension ".jade"', ->
      expect(Compiller.extension).to.equal '.jade'

    it 'should compile correct .jade file with default settings', (done) ->
      fs.readFile fixturesOk, READ_OPTIONS, (err, data) ->
        expect(err).to.be.null
        expect(data).to.be.a 'string'
        Compiller.processor data, fixturesOk, (err, code) ->
          expect(err).to.be.null
          expect(code).to.be.a 'string'

          # test result
          # looks strange, but its just <script src='./runtime.js'></script> analog
          jade_runtime_file = "#{__dirname}/../node_modules/jade/runtime.js"
          fs.readFile jade_runtime_file, READ_OPTIONS, (err, jade_runtime) ->
            expect(err).to.be.null
            expect(jade_runtime).to.be.a 'string'

            vm.runInNewContext jade_runtime, jade_sandbox = window : {}, module:exports:null
            # looks starnge, but its ok for browser
            jade_sandbox.jade = jade_sandbox.window.jade
            vm.runInNewContext code, jade_sandbox

            jadeTmpl  = jade_sandbox.module.exports
            jadeHtml  = jadeTmpl name : 'Bender'
            # console.log jadeHtml
            expect(jadeHtml).to.equal results.ok_beauty

            done()

    it 'should compile correct .jade file with custom settings', (done) ->
      fs.readFile fixturesOk, READ_OPTIONS, (err, data) ->
        expect(err).to.be.null
        expect(data).to.be.a 'string'

        # this is our settings, to print without spaces
        compiller = Compiller pretty : off

        compiller.processor data, fixturesOk, (err, code) ->
          expect(err).to.be.null
          expect(code).to.be.a 'string'

          # test result
          # looks strange, but its just <script src='./runtime.js'></script> analog
          jade_runtime_file = "#{__dirname}/../node_modules/jade/runtime.js"
          fs.readFile jade_runtime_file, READ_OPTIONS, (err, jade_runtime) ->
            expect(err).to.be.null
            expect(jade_runtime).to.be.a 'string'

            vm.runInNewContext jade_runtime, jade_sandbox = window : {}, module:exports:null
            # looks starnge, but its ok for browser
            jade_sandbox.jade = jade_sandbox.window.jade
            vm.runInNewContext code, jade_sandbox

            jadeTmpl  = jade_sandbox.module.exports
            jadeHtml  = jadeTmpl name : 'Bender'
            # console.log jadeHtml
            expect(jadeHtml).to.equal results.ok

            done()

    it 'should return error on incorrect .jade file', (done) ->
      fs.readFile fixturesErr, READ_OPTIONS, (err, data) ->
        expect(err).to.be.null
        expect(data).to.be.a 'string'
        Compiller.processor data, fixturesErr, (err, code) ->
          expect(err).to.be.an.instanceof Error

          done()

