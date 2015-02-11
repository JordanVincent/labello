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

  # Groups selections per position, depending on posType = {'startPosition', 'endPosition'}
  # return ex [
  #   selections: [selectionA, selectionB]
  #   position: 56
  # ,
  #   selections: [selectionC, selectionD]
  #   position: 85
  # ]
  groupSelectionsByPosition: (selections, posType) ->
    groupedSelections = []
    selections.forEach (selection) ->
      groupedSelection = groupedSelections.findBy('position', selection.get(posType))

      if groupedSelection
        groupedSelection.selections.pushObject(selection)
      else
        groupedSelections.pushObject
          position: selection.get(posType)
          selections: [selection]

    groupedSelections

  setContent: ->
    options =
      html: ''
      text: @get('value.text')
      startedSelections: []
      prevPosition: 0

    groupedSelections = @groupSelectionsByPosition(@get('value.selections'), 'startPosition')
    @openTags(groupedSelections, options)

    # ending
    options.html += options.text.slice(options.prevPosition)

    @$().html(options.html)

  openTags: (groupedSelections, options) ->
    groupedSelections.sortBy('position').forEach (groupedSelection) =>
      selections = groupedSelection.selections
      position   = groupedSelection.position

      # close tags
      endingSelections = options.startedSelections.filter (selection) ->
        selection.get('endPosition') <= position
      groupedEndingSelections = @groupSelectionsByPosition(endingSelections, 'endPosition')
      @closeTags(groupedEndingSelections, options)

      # open tag
      beforeText = options.text.slice(options.prevPosition, position)
      endTag =  if options.startedSelections.get('length') then '</span>' else ''

      options.startedSelections.addObjects(selections)

      spanTag = @openingSpanTag(options.startedSelections)
      options.html += beforeText + endTag + spanTag

      options.prevPosition = position

  closeTags: (groupedSelections, options) ->
    groupedSelections.sortBy('position').forEach (groupedSelection) =>
      selections = groupedSelection.selections
      position   = groupedSelection.position

      beforeText = options.text.slice(options.prevPosition, position)
      options.startedSelections.removeObjects(selections)

      spanTag = '</span>'
      spanTag += @openingSpanTag(selections) if options.startedSelections.get('length')

      options.html += beforeText + spanTag
      options.prevPosition = position

  openingSpanTag: (selections) ->
    className = selections.mapBy('id').join(' ')
    color = selections.get('lastObject.label.color')
    "<span class=\"#{className}\" style=\"color:#{color};\">"

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