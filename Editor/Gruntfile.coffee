"use strict"
LIVERELOAD_PORT = 35729
SERVER_PORT = 9000
lrSnippet = require("connect-livereload")(port: LIVERELOAD_PORT)
mountFolder = (connect, dir) ->
  connect.static require("path").resolve(dir)


# # Globbing
# for performance reasons we're only matching one level down:
# 'test/spec/{,*/}*.js'
# use this if you want to match all subfolders:
# 'test/spec/**/*.js'
# templateFramework: 'lodash'
module.exports = (grunt) ->

  # show elapsed time at the end
  require("time-grunt") grunt

  # load all grunt tasks
  require("load-grunt-tasks") grunt

  # configurable paths
  yeomanConfig =
    app: "app"
    dist: "dist"

  grunt.initConfig
    yeoman: yeomanConfig
    watch:
      options:
        nospawn: true
        livereload: true

      coffee:
        files: ["<%= yeoman.app %>/scripts/{,*/}*.coffee"]
        tasks: ["coffee:dist"]

      stylus:
        files: ["<%= yeoman.app %>/styles/{,*/}*.styl"]
        tasks: ["stylus:dist"]

      coffeeTest:
        files: ["test/spec/{,*/}*.coffee"]
        tasks: ["coffee:test"]

      livereload:
        options:
          livereload: LIVERELOAD_PORT

        files: [
          "<%= yeoman.app %>/*.html"
          "{.tmp,<%= yeoman.app %>}/styles/{,*/}*.css"
          "{.tmp,<%= yeoman.app %>}/scripts/{,*/}*.js"
          "<%= yeoman.app %>/images/{,*/}*.{png,jpg,jpeg,gif,webp}"
          "<%= yeoman.app %>/scripts/templates/*.{ejs,mustache,hbs}"
          "test/spec/**/*.js"
        ]

      jst:
        files: ["<%= yeoman.app %>/scripts/templates/*.ejs"]
        tasks: ["jst"]

      test:
        files: [
          "<%= yeoman.app %>/scripts/{,*/}*.js"
          "test/spec/**/*.js"
        ]
        tasks: ["test:true"]

    connect:
      options:
        port: SERVER_PORT

        # change this to '0.0.0.0' to access the server from outside
        hostname: "localhost"

      livereload:
        options:
          middleware: (connect) ->
            [
              lrSnippet
              mountFolder(connect, ".tmp")
              mountFolder(connect, yeomanConfig.app)
            ]

      test:
        options:
          port: 9001
          middleware: (connect) ->
            [
              lrSnippet
              mountFolder(connect, ".tmp")
              mountFolder(connect, "test")
              mountFolder(connect, yeomanConfig.app)
            ]

      dist:
        options:
          middleware: (connect) ->
            [mountFolder(connect, yeomanConfig.dist)]

    open:
      server:
        path: "http://localhost:<%= connect.options.port %>"

      test:
        path: "http://localhost:<%= connect.test.options.port %>"

    clean:
      dist: [
        ".tmp"
        "<%= yeoman.dist %>/*"
      ]
      server: ".tmp"

    jshint:
      options:
        jshintrc: ".jshintrc"
        reporter: require("jshint-stylish")

      all: [
        "Gruntfile.js"
        "<%= yeoman.app %>/scripts/{,*/}*.js"
        "!<%= yeoman.app %>/scripts/vendor/*"
        "test/spec/{,*/}*.js"
      ]

    mocha:
      all:
        options:
          run: true
          src: ["http://localhost:<%= connect.test.options.port %>/index.html"]

    coffee:
      dist:
        files: [

          # rather than compiling multiple files here you should
          # require them into your main .coffee file
          expand: true
          cwd: "<%= yeoman.app %>/scripts"
          src: "{,*/}*.coffee"
          dest: ".tmp/scripts"
          ext: ".js"
        ]

      test:
        files: [
          expand: true
          cwd: "test/spec"
          src: "{,*/}*.coffee"
          dest: ".tmp/spec"
          ext: ".js"
        ]

    stylus:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/styles"
          src: "{,*/}*.styl"
          dest: ".tmp/styles"
          ext: ".css"
        ]
    # not enabled since usemin task does concat and uglify
    # check index.html to edit your build targets
    # enable this task if you prefer defining your build targets here
    #uglify: {
    #            dist: {}
    #        },
    useminPrepare:
      html: "<%= yeoman.app %>/index.html"
      options:
        dest: "<%= yeoman.dist %>"

    usemin:
      html: ["<%= yeoman.dist %>/{,*/}*.html"]
      css: ["<%= yeoman.dist %>/styles/{,*/}*.css"]
      options:
        dirs: ["<%= yeoman.dist %>"]

    imagemin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/images"
          src: "{,*/}*.{png,jpg,jpeg}"
          dest: "<%= yeoman.dist %>/images"
        ]

    cssmin:
      dist:
        files:
          "<%= yeoman.dist %>/styles/main.css": [
            ".tmp/styles/{,*/}*.css"
            "<%= yeoman.app %>/styles/{,*/}*.css"
          ]

    htmlmin:
      dist:
        options: {}

        #removeCommentsFromCDATA: true,
        #                    // https://github.com/yeoman/grunt-usemin/issues/44
        #                    //collapseWhitespace: true,
        #                    collapseBooleanAttributes: true,
        #                    removeAttributeQuotes: true,
        #                    removeRedundantAttributes: true,
        #                    useShortDoctype: true,
        #                    removeEmptyAttributes: true,
        #                    removeOptionalTags: true
        files: [
          expand: true
          cwd: "<%= yeoman.app %>"
          src: "*.html"
          dest: "<%= yeoman.dist %>"
        ]

    copy:
      dist:
        files: [
          expand: true
          dot: true
          cwd: "<%= yeoman.app %>"
          dest: "<%= yeoman.dist %>"
          src: [
            "*.{ico,txt}"
            ".htaccess"
            "images/{,*/}*.{webp,gif}"
            "styles/fonts/{,*/}*.*"
          ]
        ]

    jst:
      compile:
        files:
          ".tmp/scripts/templates.js": ["<%= yeoman.app %>/scripts/templates/*.ejs"]

    rev:
      dist:
        files:
          src: [
            "<%= yeoman.dist %>/scripts/{,*/}*.js"
            "<%= yeoman.dist %>/styles/{,*/}*.css"
            "<%= yeoman.dist %>/images/{,*/}*.{png,jpg,jpeg,gif,webp}"
            "/styles/fonts/{,*/}*.*"
          ]

  grunt.registerTask "createDefaultTemplate", ->
    grunt.file.write ".tmp/scripts/templates.js", "this.JST = this.JST || {};"
    return

  grunt.registerTask "server", (target) ->
    grunt.log.warn "The `server` task has been deprecated. Use `grunt serve` to start a server."
    grunt.task.run ["serve" + ((if target then ":" + target else ""))]
    return

  grunt.registerTask "serve", (target) ->
    if target is "dist"
      return grunt.task.run([
        "build"
        "open:server"
        "connect:dist:keepalive"
      ])
    if target is "test"
      return grunt.task.run([
        "clean:server"
        "stylus"
        "coffee"
        "createDefaultTemplate"
        "jst"
        "connect:test"
        "open:test"
        "watch:livereload"
      ])
    grunt.task.run [
      "clean:server"
      "stylus"
      "coffee:dist"
      "createDefaultTemplate"
      "jst"
      "connect:livereload"
      "open:server"
      "watch"
    ]
    return

  grunt.registerTask "test", (isConnected) ->
    isConnected = Boolean(isConnected)
    testTasks = [
      "clean:server"
      "coffee"
      "createDefaultTemplate"
      "jst"
      "connect:test"
      "mocha"
      "watch:test"
    ]
    unless isConnected
      grunt.task.run testTasks
    else

      # already connected so not going to connect again, remove the connect:test task
      testTasks.splice testTasks.indexOf("connect:test"), 1
      grunt.task.run testTasks

  grunt.registerTask "build", [
    "clean:dist"
    "stylus"
    "coffee"
    "createDefaultTemplate"
    "jst"
    "useminPrepare"
    "imagemin"
    "htmlmin"
    "concat"
    "cssmin"
    "uglify"
    "copy"
    "rev"
    "usemin"
  ]
  grunt.registerTask "default", [
    "jshint"
    "test"
    "build"
  ]
  return