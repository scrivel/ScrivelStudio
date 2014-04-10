window.ss = window.ScrivelStudio =
  Models: {}
  Collections: {}
  Views: {}
  ViewHelpers: {}
  Routers: {}
# runtime
$ ->
  'use strict'
  # appを作成
  window.app = new ss.App
  # Demoスクリプトを読み込み
  $.ajax
    url : "./data/demo.sescript.json"
    dataType : "json"
    async : false
  .done (data)=>
    app.graphical_editor.set "elements", data.elements
  .fail (e)->
    console.log e