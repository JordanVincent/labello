`import Ember from 'ember';`

ParagraphView = Em.View.extend
  classNames: ['paragraph']

  didInsertElement: ->
    @setContent()

  valueChanged: (->
    @setContent()
  ).observes('value.text', 'value.selections.[]',
    'value.selections.@each.label', 'value.selections.@each.color')

  selectionSelected: (selection) ->
    anchorOffestPos = @posOffset(selection.anchorNode)
    selection = @get('value.selections').find (selection) ->
      selection.get('startPosition') <= anchorOffestPos and
      selection.get('endPosition') >= anchorOffestPos

  click: (event) ->
    selection = document.getSelection()

    selectedSelection = @selectionSelected(selection)
    @get('parentView').send('selectionSelected', selectedSelection) if selectedSelection

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

    # close last tags
    groupedEndingSelections = @groupSelectionsByPosition(options.startedSelections, 'endPosition')
    @closeTags(groupedEndingSelections, options)

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
      spanTag += @openingSpanTag(options.startedSelections) if options.startedSelections.get('length')

      options.html += beforeText + spanTag
      options.prevPosition = position

  openingSpanTag: (selections) ->
    className = selections.map( (selection) ->
      'selection-' + selection.get('id')
    ).join(' ')

    color = selections.get('lastObject.label.color')
    color = color[0] if Ember.isArray(color) #fix

    if selections.get('length') > 1
      otherColor = selections.get('firstObject.label.color')
      otherColor = otherColor[0] if Ember.isArray(otherColor) #fix
      color = $.xcolor.combine color, otherColor

    "<span class=\"#{className}\" style=\"color:#{color};\">"

`export default ParagraphView;`