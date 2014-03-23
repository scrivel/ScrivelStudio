'use strict';

class ss.Views.App extends Backbone.View

  el : $("#app")
  events: {}

  initialize: () ->
    @listenTo @model, 'change', @render

  render: () ->
    @$el.html @template(@model)
