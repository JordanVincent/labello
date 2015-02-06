`import Ember from 'ember';`

LabelsController = Ember.ArrayController.extend
  selectedLabel: null

  actions:
    selectLabel: (label) ->
      @set('selectedLabel', label)

`export default LabelsController;`