'use strict';

class ss.Views.MethodChain extends Backbone.View

  template: JST['app/scripts/templates/method_chain.ejs']

  tagName: 'div'

  id: ->
    this.model.uuid

  className: 'ss-object ss-method-chain'

  events: {
    "click .ss-method-chain-toggler button" : "onClickToggler"
    "click" : "onClick"
  }

  initialize: () ->
    @hidden = true
    @listenTo @model, 'change', @render
    @listenTo @model, "remove", @onModelRemove
  onClick : (e) ->
    app.set "selecedElement", this.model
    e.stopPropagation()
  onClickToggler : (e) ->
    @$methodDesc= this.$el.find(".ss-method-chain-description") unless @$methodList
    @$methodTarget = this.$el.find(".ss-method-chain-target") unless @$methodTarget
    if @hidden
      @$methodDesc.removeClass("ss-hidden")
      @$methodTarget.removeClass("ss-hidden")
    else
      @$methodDesc.addClass("ss-hidden")
      @$methodTarget.addClass("ss-hidden")
    @hidden = !@hidden
    e.stopPropagation()
  onModelRemove: ->
    @$el.remove()
  render: () ->
    @$el.html @template(@model)
    return this
