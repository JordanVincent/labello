`import Ember from 'ember';`

DocumentController = Ember.ObjectController.extend
  selectedSelection: null

  actions:
    editLabel: (label) ->
      @send 'openModal', 'label-edit-modal', label

`export default DocumentController;`