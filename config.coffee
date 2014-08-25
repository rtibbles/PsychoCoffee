exports.config =
  paths:
    watched: ['api', 'app', 'envs', 'vendor', 'test','server.coffee']
  files:
    javascripts: 
      joinTo: 
        'js/app.js': /^(app|envs\/development)/,
        'js/vendor.js': /^(vendor\/scripts\/(common|development)|vendor\\scripts\\(common|development))/
      order: 
        before: [
          'vendor/scripts/common/modernizr.min.js',
          'vendor/scripts/common/console-polyfill.js',
          'vendor/scripts/common/jquery.js',
          'vendor/scripts/common/jquery.ajax-progress.js',
          'vendor/scripts/common/handlebars.js',
          'vendor/scripts/common/underscore.js',
          'vendor/scripts/development/backbone.js',
          'vendor/scripts/common/backbone-associations-min.js',
          'vendor/scripts/common/backbone.dualstorage.amd.js',
          'vendor/scripts/common/preloadjs-0.4.1.min.js',
          'vendor/scripts/common/soundjs-0.5.2.min.js',
          'vendor/scripts/common/flashplugin-0.5.2.min.js',
          'vendor/scripts/common/fabric.min.js',
          'vendor/scripts/common/seedrandom.min.js'
        ]
    stylesheets: 
      joinTo: 
        'stylesheets/app.css': /^(app|vendor)/
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
  server:
    path: 'server.coffee'
    port: 3333
  overrides:
    # Production Settings
    production: 
      files: 
        javascripts: 
          joinTo: 
            'js/app.js': /^(app|envs\/production)/,
            'js/vendor.js': /^(vendor\/scripts\/(common|production)|vendor\\scripts\\(common|production))/
          order: 
            before: [
              'vendor/scripts/common/modernizr.min.js',
              'vendor/scripts/common/console-polyfill.js',
              'vendor/scripts/common/jquery.js',
              'vendor/scripts/common/jquery.ajax-progress.js',
              'vendor/scripts/common/handlebars.js',
              'vendor/scripts/common/underscore.js',
              'vendor/scripts/production/backbone-min.js',
              'vendor/scripts/common/backbone-associations-min.js',
              'vendor/scripts/common/backbone.dualstorage.amd.js',
              'vendor/scripts/common/preloadjs-0.4.1.min.js',
              'vendor/scripts/common/soundjs-0.5.2.min.js',
              'vendor/scripts/common/flashplugin-0.5.2.min.js',
              'vendor/scripts/common/fabric.min.js',
              'vendor/scripts/common/seedrandom.min.js'
            ]
      optimize: true
      sourceMaps: false
      plugins: 
        autoReload: 
          enabled: false

