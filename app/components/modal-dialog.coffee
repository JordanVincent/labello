`import Ember from 'ember';`

ModalDialog = Ember.Component.extend
  saveBtnName: 'Save changes'

  actions:
    cancel: ->
      @sendAction('cancel')

    save: ->
      @sendAction('save')

`export default ModalDialog;`