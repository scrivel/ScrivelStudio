'use strict';

class ss.Views.MethodChain extends Backbone.View

  template: JST['app/scripts/templates/method_chain.ejs']

  tagName: 'div'

  id: ->
    this.model.uuid

  className: 'ss-method-chain'

  events: {}

  initialize: () ->
    @listenTo @model, 'change', @render

  render: () ->
    @$el.html @template(@model)
    return this
