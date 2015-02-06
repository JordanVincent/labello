`import Ember from 'ember';`

SelectionMoveModalController = Ember.ObjectController.extend
  needs: 'project',
  project: Ember.computed.alias('controllers.project')

  modelChanged: (->
    @set 'oldLabel', @get('model.label')
  ).observes('model')

  actions:
    cancel: ->
      selection = @get('model')
      @get('oldLabel').get('selections').addObject(selection)
      selection.save().then =>
        @send('closeModal')

    save: ->
      selection = @get('model')
      selection.save().then =>
        selection.get('label.selections').addObject(selection)
        selection.save().then =>
          @send('closeModal')

      # TODO remove from old label

`export default SelectionMoveModalController;`