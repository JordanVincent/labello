`import Ember from 'ember';`

categoryEditModalController = Ember.ObjectController.extend

  actions:
    cancel: ->
      @get('model').rollback()
      @send('closeModal')
      @set('model', null)

    save: ->
      @get('model').save().then =>
        @send('closeModal')
        @set('model', null)

`export default categoryEditModalController;`