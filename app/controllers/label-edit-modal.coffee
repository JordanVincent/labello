`import Ember from 'ember';`

LabelEditModalController = Ember.ObjectController.extend

  actions:
    cancel: ->
      @send('closeModal')

    save: ->
      @get('model').save().then =>
        @send('closeModal')

`export default LabelEditModalController;`