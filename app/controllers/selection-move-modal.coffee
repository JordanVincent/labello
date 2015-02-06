`import Ember from 'ember';`

SelectionMoveModalController = Ember.ObjectController.extend
  needs: 'project',
  project: Ember.computed.alias('controllers.project')

  actions:
    cancel: ->
      @send('closeModal')

    save: ->
      selection = @get('model')
      @get('model').save().then =>
        selection.get('label.selections').addObject(selection)
        selection.save().then =>
          @send('closeModal')

      # TODO remove from old label

`export default SelectionMoveModalController;`