'use strict';

class ScrivelStudio.Views.Element extends Backbone.View

  template: JST['app/scripts/templates/element.ejs']

  tagName: 'div'

  id: ''

  className: ''

  events: {}

  initialize: () ->
    @listenTo @model, 'change', @render

  render: () ->
    @$el.html @template(@model.toJSON())
