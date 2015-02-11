`import Ember from 'ember';`

SelectionItem = Ember.Component.extend
  isSelected: (->
    @get('selection') is @get('selectedSelection')
  ).property('selection', 'selectedSelection')

  selectionClassName: (->
    'selection-' + @get('selection.id')
  ).property('selection')

  actions:
    selectSelection: (selection) ->
      @sendAction 'selectSelection', selection

    deleteSelection: (selection) ->
      @sendAction 'deleteSelection', selection

    moveSelection: (selection) ->
      @sendAction 'moveSelection', selection

`export default SelectionItem;`