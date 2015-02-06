`import Ember from 'ember';`

DocumentController = Ember.ObjectController.extend
  selectedSelection: null

  actions:
    editLabel: (label) ->
      @send 'openModal', 'label-edit-modal', label

    moveSelection: (selection) ->
      @send 'openModal', 'selection-move-modal', selection

`export default DocumentController;`