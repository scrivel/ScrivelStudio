'use strict';

class ss.Views.App extends Backbone.View

  template: JST['app/scripts/templates/ss.ejs']

  tagName: 'div'

  id: ''

  className: ''

  events: {}

  initialize: () ->
    @listenTo @model, 'change', @render

  render: () ->
    @$el.html @template(@model.toJSON())
