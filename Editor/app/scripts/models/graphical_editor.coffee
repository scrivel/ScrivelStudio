class ss.Models.GraphicalEditor extends Backbone.Model
  initialize: (obj = {elements : []})->
    # collectionを作成
    @elements = new ss.Collections.Element
    # viewを作成
    @view = new ss.Views.GraphicalEditor {
      model : this
    }
    this.on "change:elements", this.onChangeElements
    this.listenTo @elements, "add", this.onAddElement
    this.listenTo @elements, "remove", this.onRemoveEelement
  defaults:
    "elements": []
  onChangeElements: (model,elements,opts) ->
    @elements.reset()
    @elements.add _.map(elements, (elem) ->
      if elem.type
        return new ss.Models.MethodChain elem
      else if elem.character
        return new ss.Models.Words elem
    ), {silent : true}
    df = document.createDocumentFragment()
    @elements.each (elem) ->
      if elem instanceof ss.Models.MethodChain
        v = new ss.Views.MethodChain {
          model : elem
        }
        elem.view = v
        df.appendChild v.render().el
      else if elem instanceof ss.Models.Words
        v = new ss.Views.Words {
          model : elem
        }
        elem.view = v
        df.appendChild v.render().el
    @view.$el.append df
  onAddElement: (model, elements, opts)->
    idx = if opts.at then opts.at else elements.length
    elem = elements.at idx-1
    if model instanceof ss.Models.Words
      v = new ss.Views.Words {
        model : model
      }
    else if model instanceof ss.Models.MethodChain
      v = new ss.Views.MethodChain {
        model : model
      }
    v.render().$el.insertAfter elem.view.$el
    v.$name.focus()
  onRemoveEelement: ()->
