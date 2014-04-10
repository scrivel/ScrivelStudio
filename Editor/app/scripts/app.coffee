'use strict'
class ss.App extends Backbone.Model
  initialize: ->
    'use strict'
    console.log 'Hello from Backbone!'
    # グラフィカルエディタを作成
    @graphical_editor = new ss.Models.GraphicalEditor
    this.on "change:selecedElement", this.onChangeSelectedElement
    window.onkeydown = @onKeyDown
    window.onkeyup = @onKeyUp
    window.onkeypress = @onKeyPress
  onKeyDown: (e) =>
    console.log this
    elem = app.get("selecedElement")
    if elem
      idx = @graphical_editor.elements.models.indexOf elem
      switch e.keyCode
        when 40
          # 下
          idx++
        when 38
          # 上
          idx--
      app.set "selecedElement", @graphical_editor.elements.at idx
      e.stopPropagation()
      e.preventDefault()
  onKeyPress: (e)->
    console.log e
  onKeyUp : (e) ->
    elem = app.get "selecedElement"
    if e.keyCode is 8 and elem
      elem.destroy()
  onChangeSelectedElement: (model, elem, opts) ->
    console.log elem
    if elem
      elem.view.$el.addClass "ss-selected"
    if @previousElement
      @previousElement.view.$el.removeClass "ss-selected"
    @previousElement = elem