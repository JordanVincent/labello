`import Ember from 'ember';`

SelectionMoveModalController = Ember.ObjectController.extend
  needs: 'project'
  project: Ember.computed.alias('controllers.project')
  oldLabel: null
  label: null
  newLabel: null

  modelChanged: (->
    return unless @get('model')
    @get('model.label').then (label) =>
      @set 'oldLabel', label
      @set 'newLabel', label
  ).observes('model')

  actions:
    cancel: ->
      selection = @get('model')
      @get('oldLabel').get('selections').addObject(selection)
      selection.save().then =>
        @send('closeModal')
        @set('model', null)

    save: ->
      selection = @get('model')
      selection.save().then =>
        @get('oldLabel').get('selections').removeObject(selection)
        @get('oldLabel').save().then =>

          newLabel = @get('newLabel')
          newLabel.get('selections').addObject(selection)
          newLabel.save().then =>
            @send('closeModal')
            @set('model', null)

`export default SelectionMoveModalController;`