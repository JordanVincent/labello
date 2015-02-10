`import Ember from 'ember';`

TextSelection = Ember.Component.extend
  classNames: ['text-selection']
  popoverTop: 0
  popoverLeft: 0
  popoverPosition: 'bottom'
  popoverDisplayed: false
  currentSelection: null
  newLabelName: null

  popoverStyle: (->
    'top: ' + @get('popoverTop') + 'px; left: ' + @get('popoverLeft') + 'px;'
  ).property('popoverTop', 'popoverLeft')

  popoverArrowStyle: ( ->
    leftPostion = if @get('popoverLeft') <= 10 then '20%' else '50%'
    'left: ' + leftPostion + ';'
  ).property('popoverLeft')

  showPopover: (event) ->
    @set('popoverDisplayed', true)

    popoverWidth = @$('.popover').width()
    popoverHeight = @$('.popover').height() + 10
    popoverTop = event.clientY
    popoverLeft = event.clientX - popoverWidth/2

    if (popoverTop + popoverHeight > $(window).height())
      popoverTop = popoverTop - popoverHeight
      @set('popoverPosition', 'top')
    else @set('popoverPosition', 'bottom')

    popoverLeft = if popoverLeft < 0 then 10 else popoverLeft

    @set 'popoverTop', popoverTop
    @set 'popoverLeft', popoverLeft

  dismissSelection: (event) ->
    @set('currentSelection', null)
    @set('popoverDisplayed', false)

  actions:
    dismiss: ->
      return unless @get('popoverDisplayed')
      @dismissSelection()

    selection: (paragraph, startPos, endPos, event) ->
      @set 'currentSelection', Ember.Object.create
        paragraph: paragraph
        startPos: startPos
        endPos: endPos

      @showPopover(event)

    selectLabel: (label) ->
      selection = @get('currentSelection')
      @sendAction('createSelection', label, selection.get('paragraph'), selection.get('startPos'), selection.get('endPos'))
      @dismissSelection()

    createLabel: (labelName) ->
      selection = @get('currentSelection')
      @sendAction('createLabel', labelName, selection.get('paragraph'), selection.get('startPos'), selection.get('endPos'))
      @dismissSelection()
      @set('newLabelName', null)

`export default TextSelection;`