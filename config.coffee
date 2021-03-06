exports.config =
  paths:
    watched: ['app', 'envs', 'vendor']
  files:
    javascripts: 
      joinTo:
        'js/experiment_editor.js': /^(app|envs\/development)(\/|\\)experiment_editor/,
        'js/app.js': /^(app|envs\/development)(\/|\\)(?!experiment_editor)/,
        'js/vendor.js': /^(vendor\/scripts\/(common|development)|vendor\\scripts\\(common|development))/,
        'js/editor_vendor.js': /^(vendor\/scripts\/experiment_editor|vendor\\scripts\\experiment_editor)/
        'js/editor_blockly.js': /^(vendor\/scripts\/editor_blockly|vendor\\scripts\\editor_blockly)/
      order: 
        before: [
          'vendor/scripts/common/es5-shim.min.js',
          'vendor/scripts/common/modernizr.min.js',
          'vendor/scripts/common/console-polyfill.js',
          'vendor/scripts/development/jquery-1.11.1.js',
          'vendor/scripts/common/jquery.ajax-progress.js',
          'vendor/scripts/common/handlebars.js',
          'vendor/scripts/common/underscore.js',
          'vendor/scripts/development/backbone.js',
          'vendor/scripts/common/backbone-associations-min.js',
          'vendor/scripts/common/backbone.dualstorage.amd.js',
          'vendor/scripts/common/preloadjs-0.6.0.min.js',
          'vendor/scripts/common/soundjs-0.6.0.min.js',
          'vendor/scripts/common/flashaudioplugin-0.6.0.min.js',
          'vendor/scripts/common/fabric.min.js',
          'vendor/scripts/common/seedrandom.min.js',
          'vendor/scripts/common/md5.js',
          'vendor/scripts/editor_blockly/blockly_compressed.js',
          'vendor/scripts/editor_blockly/blocks_compressed.js',
          'vendor/scripts/experiment_editor/jquery-ui.js'
        ]
    stylesheets: 
      joinTo: 
        'stylesheets/app.css': /^(app|vendor\/styles)(\/|\\)(?!experiment_editor)/
        'stylesheets/experiment_editor.css': /^(app|vendor\/styles)(\/|\\)experiment_editor/
      order: 
        before: ['vendor/styles/normalize.css']
    templates: 
      precompile: true
      root: 'templates'
      joinTo: 
        'js/app.js': /^app/
  plugins:
    coffeelint:
      options:
        indentation:
            value: 4
    uglify:
          mangle: true
          compress:
            global_defs: 
              DEBUG: false
  server:
    path: 'server.coffee'
    port: 3333
  overrides:
    # Production Settings
    production: 
      files: 
        javascripts: 
          joinTo:
            'js/experiment_editor.js': /^(app|envs\/production)(\/|\\)experiment_editor/,
            'js/app.js': /^(app|envs\/production)(\/|\\)(?!experiment_editor)/,
            'js/vendor.js': /^(vendor\/scripts\/(common|production)|vendor\\scripts\\(common|production))/,
            'js/editor_vendor.js': /^(vendor\/scripts\/experiment_editor|vendor\\scripts\\experiment_editor)/
            'js/editor_blockly.js': /^(vendor\/scripts\/editor_blockly|vendor\\scripts\\editor_blockly)/
          order: 
            before: [
              'vendor/scripts/common/es5-shim.min.js',
              'vendor/scripts/common/modernizr.min.js',
              'vendor/scripts/common/console-polyfill.js',
              'vendor/scripts/production/jquery-1.11.1.min.js',
              'vendor/scripts/common/jquery.ajax-progress.js',
              'vendor/scripts/common/handlebars.js',
              'vendor/scripts/common/underscore.js',
              'vendor/scripts/production/backbone-min.js',
              'vendor/scripts/common/backbone-associations-min.js',
              'vendor/scripts/common/backbone.dualstorage.amd.js',
              'vendor/scripts/common/preloadjs-0.6.0.min.js',
              'vendor/scripts/common/soundjs-0.6.0.min.js',
              'vendor/scripts/common/flashaudioplugin-0.6.0.min.js',
              'vendor/scripts/common/fabric.min.js',
              'vendor/scripts/common/seedrandom.min.js',
              'vendor/scripts/common/md5.js',
              'vendor/scripts/editor_blockly/blockly_compressed.js',
              'vendor/scripts/editor_blockly/blocks_compressed.js'
            ]
      optimize: true
      sourceMaps: false
      plugins: 
        autoReload: 
          enabled: false

