`import Ember from 'ember';`

ParagraphView = Em.View.extend
  classNames: ['paragraph']

  didInsertElement: ->
    @setContent()

  valueChanged: (->
    @setContent()
  ).observes('value.text', 'value.selections.[]', 'value.selections.@each.label')

  click: (event) ->
    selection = document.getSelection()
    return unless @isSelectionValid(selection)
    event.stopPropagation()

    offestPos = 0
    flag = false
    $(selection.anchorNode).parent().contents().each (index, content) ->
      if $(content).is($(selection.anchorNode)) or flag
        flag = true
      else
        offestPos += $(content).text().length


    startPos = selection.anchorOffset + offestPos
    endPos = selection.extentOffset + offestPos
    if startPos > endPos
      buffer = startPos
      startPos = endPos
      endPos = buffer

    @get('parentView').send('selection', @get('value'), startPos, endPos, event)

  isSelectionValid: (selection) ->
    (selection.type is 'Range') and
    (selection.anchorNode is selection.extentNode)

  setContent: ->
    html = @get('value.text')

    startPos = []
    endPos = []

    @get('value.selections').sortBy('startPosition').reverse().forEach (selection) =>

      startPos = selection.get('startPosition')
      endPos = selection.get('endPosition')
      console.log startPos, '-', endPos

      start = html.slice(0, startPos)
      middle = html.slice(startPos, endPos)
      end = html.slice(endPos)

      html = start + '<span id="' + selection.get('id') + '" style="color:' + selection.get('label.color') + ';">' + middle + '</span>' + end

    @$().html html



`export default ParagraphView;`