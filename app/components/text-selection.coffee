`import Ember from 'ember';`

TextSelection = Ember.Component.extend
  classNames: ['text-selection']
  popoverTop: 0
  popoverLeft: 0
  popoverDisplayed: false
  currentSelection: null

  popoverStyle: (->
    'top: ' + (@get('popoverTop') - 70) + 'px; left: ' + @get('popoverLeft') + 'px;'
  ).property('popoverTop', 'popoverLeft')


  showPopover: (event) ->
    @set('popoverTop', event.clientY)
    @set('popoverLeft', event.clientX)
    @set('popoverDisplayed', true)

  dismissSelection: (event) ->
    @set('currentSelection', null)
    @set('popoverDisplayed', false)

  actions:
    dismiss: ->
      console.log 'dismiss'

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

`export default TextSelection;`