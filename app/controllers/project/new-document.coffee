`import Ember from 'ember';`
`import EmberValidations from 'ember-validations';`

ProjectNewDocumentController = Ember.ObjectController.extend EmberValidations.Mixin,
  isProcessing: false
  isSubmitted: false
  showErrors: Ember.computed.and('isInvalid', 'isSubmitted')

  modelChanged: (->
    @set('isSubmitted', false)
    @set('isProcessing', false)
  ).observes('model')

  actions:
    save: (doc) ->
      @set('isSubmitted', true)
      @validate().then =>
        @set('isProcessing', true)
        Ember.run.later( =>
          @send('saveDocument', doc)
        , 100)

  validations:
    title:
      presence: true
    text:
      presence: true

`export default ProjectNewDocumentController;`