'use strict';

class ss.Views.Words extends Backbone.View

  template: JST['app/scripts/templates/words.ejs']

  tagName: 'div'

  id: ->
    this.model.uuid

  className: 'ss-words'

  events: {}

  initialize: () ->
    @listenTo @model, 'change', @render

  render: () ->
    @$el.html @template(@model)
    return this
