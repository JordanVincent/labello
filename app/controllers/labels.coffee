`import Ember from 'ember';`

LabelsController = Ember.ArrayController.extend
  singleLabels: null

  singleLabelsObs: (->
    Ember.RSVP.all(@get('model').map (label) ->
      label.get('category').then (category) ->
        label unless category
    ).then (singleLabels) =>
      @set 'singleLabels', singleLabels.compact().sortBy('name')
  ).observes('@each.category')

  actions:
    editLabel: (label) ->
      @send 'openModal', 'label-edit-modal', label

`export default LabelsController;`