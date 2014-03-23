window.ss = window.ScrivelStudio =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
# runtime
$ ->
  'use strict'
  window.app = new ss.App
  app.view = new ss.Views.App {
    model : app
  }
  app.elements = new ss.Collections.Element
  $.ajax
    url : "./data/demo.sescript.json"
    dataType : "json"
    async : false
  .done (data)->
    app.elements.add _.map data.elements, (e) ->
      if e.type
        return new ss.Models.MethodChain e
      else if e.character
        return new ss.Models.Words e
    df = document.createDocumentFragment()
    app.elements.each (elem) ->
      if elem instanceof ss.Models.MethodChain
        v = new ss.Views.MethodChain {
          model : elem
        }
        df.appendChild v.render().el
      else if elem instanceof ss.Models.Words
        v = new ss.Views.Words {
          model : elem
        }
        df.appendChild v.render().el
    app.view.$el.append df
    console.log data
  .fail (e)->
    console.log e