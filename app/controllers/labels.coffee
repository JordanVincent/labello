`import Ember from 'ember';`

LabelsController = Ember.ArrayController.extend
  singleLabels: Ember.computed.filterBy('content','category', null)

`export default LabelsController;`