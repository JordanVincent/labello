`import Ember from 'ember';`

ParagraphView = Em.View.extend
  classNames: ['paragraph']

  didInsertElement: ->
    @setContent()

  valueChanged: (->
    @setContent()
  ).observes('value.text', 'value.selections.[]')

  mouseUp: (event) ->

    selection = document.getSelection()
    console.log selection
    return unless @isSelectionValid(selection)

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
    console.log offestPos, selection.anchorOffset, selection.extentOffset
    @get('parentView').send('selection', @get('value'), startPos, endPos, event)

    # text = $(selection.anchorNode).parent().html()
    # # console.log 'text', text
    # start = text.slice(0, selection.anchorOffset)
    # middle = text.slice(selection.anchorOffset, selection.extentOffset)
    # end = text.slice(selection.extentOffset)

    # newText = start + '<b>' + middle + '</b>' + end

    # $(selection.anchorNode).parent().html(newText)
    # console.log newText, $(selection.anchorNode)
    # @sendAction('createLabel')
    # @updateValue()

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

      html = start + '<span style="color:' + selection.get('label.color') + ';">' + middle + '</span>' + end

    @$().html html



`export default ParagraphView;`