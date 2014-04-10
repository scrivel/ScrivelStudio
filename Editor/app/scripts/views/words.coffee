'use strict';

class ss.Views.Words extends Backbone.View

  template: JST['app/scripts/templates/words.ejs']

  tagName: 'div'

  id: ->
    this.model.uuid

  className: 'ss-words'

  events: {
    "keydown" : "onKeyDown"
    "keypress" : "onKeyPress"
    "keyup" : "onKeyUp"
    "blur .ss-input" : "onBlur"
    # "input .ss-input" : "onInput"
    # "focus" : "onFocus"
  }

  initialize: () ->
    @listenTo @model, 'change', @render
    @listenTo @model, 'remove', @onModelRemove
  isEmpty: ->
    return @$name.text().length is 0 and @$text.text().length is 0
  onBlur : (e) ->
    if @isEmpty()
      this.model.destroy()
    else
      $target = $(e.target)
      if $target.hasClass "ss-words-name"
        this.model.set "character", $target.text()
      else if $target.hasClass "ss-words-text"
        this.model.set "arguments", [$target.text(),{}]
  onKeyDown : (e) ->
    if e.keyCode is 13 and e.shiftKey
      e.stopPropagation()
      e.preventDefault()
  onKeyPress : (e) ->
    if e.keyCode is 13 and e.shiftKey
      e.stopPropagation()
      e.preventDefault()
  onKeyUp : (e) ->
    if e.keyCode is 13 and e.shiftKey and $(e.target).hasClass("ss-words-text")
      # 伝播を止める
      e.stopPropagation()
      # デフォルトの動作を止める
      e.preventDefault()
      words = new ss.Models.Words
      idx = app.graphical_editor.elements.models.indexOf this.model
      app.graphical_editor.elements.add words, { at : idx + 1}
      # enter
    console.log e
  onModelRemove : ->
    this.$el.remove()
  render: () ->
    @$el.html @template(@model)
    @$name = this.$el.find(".ss-words-name") unless @$name
    @$text = this.$el.find(".ss-words-text") unless @$text
    return this
