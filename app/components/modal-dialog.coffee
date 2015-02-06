`import Ember from 'ember';`

ModalDialog = Ember.Component.extend

  actions:
    cancel: ->
      @sendAction('cancel')

    save: ->
      @sendAction('save')

`export default ModalDialog;`