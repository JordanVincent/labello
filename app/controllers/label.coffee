`import Ember from 'ember';`

LabelController = Ember.ObjectController.extend
  selectedSelection: null

  actions:
    selectSelection: (selection) ->
      @set('selectedSelection', selection)

    moveSelection: (selection) ->
      @send 'openModal', 'selection-move-modal', selection

`export default LabelController;`