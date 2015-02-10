`import Ember from 'ember';`

ProjectNewDocumentController = Ember.ObjectController.extend
  isProcessing: false

  actions:
    save: (doc) ->
      @set('isProcessing', true)
      Ember.run.later( =>
        @send('saveDocument', doc)
      , 100)

`export default ProjectNewDocumentController;`