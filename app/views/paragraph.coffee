`import Ember from 'ember';`

ParagraphView = Em.View.extend
  classNames: ['paragraph']

  didInsertElement: ->
    @setContent()

  paragraphChanged: (->
    @setContent()
  ).observes('paragraph.text', 'activeSelections.[]',
    'activeSelections.@each.label', 'activeSelections.@each.color')

  selectionClicked: (selection) ->
    anchorOffestPos = @posOffset(selection.anchorNode)
    selection = @get('activeSelections').find (selection) ->
      selection.get('startPosition') <= anchorOffestPos and
      selection.get('endPosition') >= anchorOffestPos

  textClicked: (selection) ->
    selectedSelection = @selectionClicked(selection)
    return unless selectedSelection
    @get('controller').send('selectionSelected', selectedSelection)

  click: (event) ->
    selection = document.getSelection()

    if @isSelectionValid(selection)
      @textSelected(event, selection)
    else @textClicked(selection)

  textSelected: (event, selection) ->
    event.stopPropagation()

    startPos = selection.anchorOffset + @posOffset(selection.anchorNode)
    endPos   = selection.extentOffset + @posOffset(selection.extentNode)

    # Inverse positions
    if startPos > endPos
      buffer   = startPos
      startPos = endPos
      endPos   = buffer

    @get('parentView').send('selection', @get('paragraph'), startPos, endPos, event)

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
    @$().html @buildHtml()

  buildHtml: ->
    options =
      html: ''
      text: @get('paragraph.text')
      startedSelections: []
      prevPosition: 0

    groupedSelections = @groupSelectionsByPosition(@get('activeSelections'), 'startPosition')
    @openTags(groupedSelections, options)

    # close last tags
    groupedEndingSelections = @groupSelectionsByPosition(options.startedSelections, 'endPosition')
    @closeTags(groupedEndingSelections, options)

    # ending
    options.html += options.text.slice(options.prevPosition)

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
      if options.startedSelections.get('length')
        spanTag += @openingSpanTag(options.startedSelections)

      options.html += beforeText + spanTag
      options.prevPosition = position

  openingSpanTag: (selections) ->
    className = selections.map( (selection) ->
      'selection-' + selection.get('id')
    ).join(' ')

    color = selections.get('lastObject.label.color')
    color = color[0] if Ember.isArray(color) #fix
    otherColor = color

    if selections.get('length') > 1
      otherColor = selections.get('firstObject.label.color')
      otherColor = otherColor[0] if Ember.isArray(otherColor) #fix

    color = $.xcolor.average(color, otherColor)
    
    # BUGFIX: Some selections don't have a label
    return "<span>" unless color
    color.a = 0.5 # alpha channel

    "<span class=\"#{className}\" style=\"background-color:#{color.getCSS()}; " +
    "border: 1px solid #{color.getCSS()}; border-radius:3px;\">"

`export default ParagraphView;`
