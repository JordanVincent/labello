`import Ember from 'ember';`

ProjectUploadModalController = Ember.ObjectController.extend

  actions:
    cancel: ->
      @send('closeModal')
      @set('model', null)

    save: ->
      json = JSON.parse @get('model')
      @send('loadProjectFromJson', json)

`export default ProjectUploadModalController;`