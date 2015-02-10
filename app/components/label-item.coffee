`import Ember from 'ember';`

LabelItem = Ember.Component.extend

  actions:
    editLabel: ->
      @sendAction 'editLabel', @get('label')

`export default LabelItem;`