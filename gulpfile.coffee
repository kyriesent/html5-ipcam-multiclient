gulp = require 'gulp'
gutil = require 'gulp-util'

{print} = require 'util'
{spawn} = require 'child_process'

gulp.task 'coffee', ->
  options = ['-w', '-c', '-o', 'lib', 'src']
  coffee = spawn 'coffee', options
  coffee.stderr.on 'data', (data) ->
    coffee = spawn 'node_modules\\.bin\\coffee.cmd', options
    coffee.stdout.on 'data', (data) ->
      console.log data.toString().trim()
    coffee.stderr.on 'data', (data) ->
      console.log data.toString().trim()
  coffee.on 'error', (error) ->
    coffee = spawn 'node_modules\\.bin\\coffee.cmd', options
    coffee.stdout.on 'data', (data) ->
      console.log data.toString().trim()
    coffee.stderr.on 'data', (data) ->
      console.log data.toString().trim()
  coffee.stdout.on 'data', (data) ->
    print data.toString()

browserify = require 'browserify'
watchify = require 'watchify'
source = require 'vinyl-source-stream'

gulp.task 'scripts', ->
  b = browserify 
    extensions: '.coffee'
    noParse: ['jquery']
    cache: {}
    packageCache: {}
    fullPaths: true
  b = watchify b
  b.add './public_src/main.coffee'
    .transform 'coffeeify'
    .bundle()
    .pipe source 'main.js'
    .pipe gulp.dest './public'
  
  b.on 'update', ->
    console.log 'Rebundling'
    b.bundle()
      .pipe source 'main.js'
      .pipe gulp.dest './public'

gulp.task 'default', ['coffee', 'scripts']