`import Ember from 'ember';`

RecordEditModalController = Ember.Mixin.create

  actions:
    cancel: ->
      @get('model').rollback()
      @send('closeModal')
      @set('model', null)

    save: ->
      @get('model').save().then =>
        @send('closeModal')
        @set('model', null)

`export default RecordEditModalController;`