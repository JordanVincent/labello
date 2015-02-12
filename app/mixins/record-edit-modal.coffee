`import Ember from 'ember';`

recordEditModalController = Ember.Mixin.create

  actions:
    cancel: ->
      @get('model').rollback()
      @send('closeModal')
      @set('model', null)

    save: ->
      @get('model').save().then =>
        @send('closeModal')
        @set('model', null)

`export default recordEditModalController;`