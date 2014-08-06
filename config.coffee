exports.config =
  paths:
    watched: ['api', 'app', 'envs', 'vendor', 'test','server.coffee']
  files:
    javascripts: 
      joinTo: 
        'javascripts/app.js': /^(app|envs\/development)/,
        'javascripts/vendor.js': /^(vendor\/scripts\/(common|development)|vendor\\scripts\\(common|development))/
      order: 
        before: [
          'vendor/scripts/common/console-polyfill.js',
          'vendor/scripts/common/jquery.js',
          'vendor/scripts/common/handlebars.js',
          'vendor/scripts/common/underscore.js',
          'vendor/scripts/development/backbone.js',
          'vendor/scripts/common/backbone-associations-min.js',
          'vendor/scripts/common/backbone.dualstorage.amd.js'
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
        'javascripts/app.js': /^app/
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
            'javascripts/app.js': /^(app|envs\/production)/,
            'javascripts/vendor.js': /^(vendor\/scripts\/(common|production)|vendor\\scripts\\(common|production))/
          order: 
            before: [
              'vendor/scripts/common/console-polyfill.js',
              'vendor/scripts/common/jquery.js',
              'vendor/scripts/common/handlebars.js',
              'vendor/scripts/common/underscore.js',
              'vendor/scripts/production/backbone-min.js',
              'vendor/scripts/common/backbone-associations-min.js',
              'vendor/scripts/common/backbone.dualstorage.amd.js'
            ]
      optimize: true
      sourceMaps: false
      plugins: 
        autoReload: 
          enabled: false

