`import Ember from 'ember';`

NewLabelModalController = Ember.ObjectController.extend
  needs: 'project'
  project: Ember.computed.alias('controllers.project.model')

  actions:
    cancel: ->
      @get('model').destroyRecord().then =>
        @send('closeModal')
        @set('model', null)

    save: ->
      label = @get('model')
      project = @get('project')

      label.set('project', project)
      label.save().then =>
        project.get('labels').addObject(label)
        project.save().then =>
          @send('closeModal')
          @set('model', null)

`export default NewLabelModalController;`