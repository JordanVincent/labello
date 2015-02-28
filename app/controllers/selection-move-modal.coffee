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
      @get('oldLabel.selections').addObject(selection)
      selection.save().then =>
        @send('closeModal')
        @set('model', null)

    save: ->
      selection = @get('model')

      @get('oldLabel.selections').removeObject(selection)
      @get('oldLabel').save().then =>

        @get('newLabel.selections').addObject(selection)
        @get('newLabel').save().then =>

          selection.save().then =>
            @send('closeModal')
            @set('model', null)

`export default SelectionMoveModalController;`