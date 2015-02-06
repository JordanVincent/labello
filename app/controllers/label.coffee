`import Ember from 'ember';`

LabelController = Ember.ObjectController.extend
  selectedSelection: null

  actions:
    selectSelection: (selection) ->
      @set('selectedSelection', selection)

`export default LabelController;`