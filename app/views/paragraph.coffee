`import Ember from 'ember';`

ParagraphView = Em.View.extend
  classNames: ['paragraph']

  didInsertElement: ->
    @setContent()

  valueChanged: (->
    @setContent()
  ).observes('value.text', 'value.selections.[]',
    'value.selections.@each.label', 'value.selections.@each.color')

  click: (event) ->
    selection = document.getSelection()
    return unless @isSelectionValid(selection)
    event.stopPropagation()

    anchorOffestPos = @posOffset(selection.anchorNode)
    extentOffestPos = @posOffset(selection.extentNode)

    startPos = selection.anchorOffset + anchorOffestPos
    endPos = selection.extentOffset + extentOffestPos
    if startPos > endPos
      buffer = startPos
      startPos = endPos
      endPos = buffer

    console.log 'select', startPos, '-', endPos, selection

    @get('parentView').send('selection', @get('value'), startPos, endPos, event)

  posOffset: (node) ->
    flag = false
    offsetPos = 0

    $node = $(node)
    parent = $node.parent()
    parent = parent.parent() if parent.is('span')

    parent.contents().each (index, content) ->

      if flag or content is node or $(content).contents()[0] is node
        flag = true
      else
        offsetPos += $(content).text().length

    offsetPos

  isSelectionValid: (selection) ->
    selection.type is 'Range'

  sfd: (selections, posType) ->
    multipleSelections = []
    selections.forEach (selection) ->
      multipleSelection = multipleSelections.findBy('position', selection.get(posType))

      if multipleSelection
        multipleSelection.selections.pushObject(selection)
      else
        multipleSelections.pushObject
          position: selection.get(posType)
          selections: [selection]

    multipleSelections

  setContent: ->
    html = ''
    text = @get('value.text')
    startedSelections = []
    prevPosition = 0
    multipleStartingSelections = @sfd(@get('value.selections'), 'startPosition')
    console.log 'multipleStartingSelections', multipleStartingSelections, text

    multipleStartingSelections.sortBy('position').forEach (multipleSelection) =>
      selections = multipleSelection.selections
      position   = multipleSelection.position

      endingSelections = startedSelections.sortBy('endPosition').filter (selection) ->
        selection.get('endPosition') <= position
      multipleEndingSelections = @sfd(endingSelections, 'endPosition')

      # zefsef
      multipleEndingSelections.sortBy('position').forEach (multipleEndingSelection) =>
        endingSelections = multipleEndingSelection.selections
        endingPosition   = multipleEndingSelection.position

        endingBeforeText = text.slice(prevPosition, endingPosition)
        startedSelections.removeObjects(endingSelections)

        endingTag = '</span>'
        if startedSelections.get('length')
          className = startedSelections.mapBy('id').join(' ')
          endingTag += '<span class="' + className + '"style="color:' + startedSelections.get('lastObject.label.color') + ';">'
        html+= endingBeforeText + endingTag
        prevPosition = endingPosition
      # end zefsef

      beforeText = text.slice(prevPosition, position)
      endTag = ''
      endTag = '</span>' if startedSelections.get('length')

      startedSelections.addObjects(selections)
      className = startedSelections.mapBy('id').join(' ')
      spanTag = '<span class="' + className + '" style="color:' + startedSelections.get('lastObject.label.color') + ';">'
      html += beforeText + endTag + spanTag

      prevPosition = position

    # ending
    end = text.slice(prevPosition)
    html += end

    @$().html(html)

  setContentOld: ->
    html = ''
    text = @get('value.text')

    spanPositions = []

    console.log('selections', @get('value.selections').sortBy('startPosition'))
    @get('value.selections').sortBy('startPosition').forEach (selection) =>
      # start

      spanPosition = spanPositions.find (spanPosition) ->
        spanPosition.type is 'start' and spanPosition.position is selection.get('startPosition')

      if spanPosition
        spanPosition.selections.pushObject(selection)
      else
        spanPositions.pushObject
          selections: [selection]
          position: selection.get('startPosition')
          type: 'start'

      # end
      spanPosition = spanPositions.find (spanPosition) ->
        spanPosition.type is 'end' and spanPosition.position is selection.get('endPosition')

      if spanPosition
        spanPosition.selections.pushObject(selection)
      else
        spanPositions.pushObject
          selections: [selection]
          position: selection.get('endPosition')
          type: 'end'

    prevSpanPosition = null
    console.log 'SPANPOS', spanPositions.sortBy('position')

    spanPositions.sortBy('position').forEach (spanPosition) =>
      prevPos = if prevSpanPosition then prevSpanPosition.position else 0
      pos = spanPosition.position

      before = text.slice(prevPos, pos)

      spanTag = ''
      if spanPosition.type is 'start'
        selections = spanPosition.selections
        className = selections.mapBy('id').join(' ')

        spanTag = '<span class="' + className + '" style="color:' + selections.objectAt(0).get('label.color') + ';">'
      else
        spanTag = '</span>'

      addition = ''
      if prevSpanPosition
        if prevSpanPosition.type is 'start' and spanPosition.type is 'start'
          addition = before + '</span>' + spanTag
        else if prevSpanPosition.type is 'end' and spanPosition.type is 'end'
          selections = prevSpanPosition.selections
          className = selections.mapBy('id').join(' ')
          addition = before + spanTag + '<span class="' + className + '" style="color:' + selections.objectAt(0).get('label.color') + ';">'
        
        else
          addition = before + spanTag
      else
        addition = before + spanTag


      console.log 'display', prevPos, '-', pos, before, spanTag
      html = html + addition

      prevSpanPosition = spanPosition

    # ending
    endPos = if prevSpanPosition then prevSpanPosition.position else 0
    end = text.slice(endPos)
    html += end

    @$().html html



`export default ParagraphView;`