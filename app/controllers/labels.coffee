`import Ember from 'ember';`

LabelsController = Ember.ArrayController.extend
  singleLabels: null

  singleLabelsObs: (->
    Ember.RSVP.all(@get('model').map (label) ->
      label.get('category').then (category) ->
        label unless category
    ).then (singleLabels) =>
      @set 'singleLabels', singleLabels.compact()
  ).observes('@each.category')

`export default LabelsController;`