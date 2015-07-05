[![Dependency Status](https://gemnasium.com/Meettya/clinch.jade.svg)](https://gemnasium.com/Meettya/clinch.jade)
[![Build Status](https://travis-ci.org/Meettya/clinch.jade.svg?branch=master)](https://travis-ci.org/Meettya/clinch.jade)

# clinch.jade

This is external addon for [clinch](https://github.com/Meettya/clinch) - CommonJS to browser packer to support ```.jade``` template files.

## How to use

    Clinch = require 'clinch'
    clinch_jade = require 'clinch.jade'

    # create packer object
    packer = new Clinch runtime : on
    # add plugin (chainable)
    packer.addPlugin clinch_jade
    # or with some settings
    packer.addPlugin clinch_jade pretty : off

For more information see main module documentation.

## Some things about jade

Compiled [client-mode](https://github.com/visionmedia/jade#a4) template may be used via `require()`. More info in test, also we are have wiki example [jade template engine](https://github.com/Meettya/clinch/wiki/Jade-template-engine-support). You must use `runtime.js` from **Jade** in browser.

**Jade** fast and elegant, and compile to less SLOC than `.eco` in case of using runtime lib.
