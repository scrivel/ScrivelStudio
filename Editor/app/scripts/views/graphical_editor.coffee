'use strict';

class ss.Views.GraphicalEditor extends Backbone.View

  el : $("#ss-graphical-editor")

  events: {
    "click" : "onClick"
  }

  onClick : (e) ->
    app.set "selecedElement", null