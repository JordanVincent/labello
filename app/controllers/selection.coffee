`import Ember from 'ember';`

SelectionController = Ember.ObjectController.extend
  activeSelections: (->
    [@get('model')]
  ).property('model')

`export default SelectionController;`