window.ss = window.ScrivelStudio =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
# runtime
$ ->
  'use strict'
  @app = new ss.App
  @app.init()