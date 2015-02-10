`import Ember from 'ember';`

NewCategoryModalController = Ember.ObjectController.extend
  needs: 'project'
  project: Ember.computed.alias('controllers.project.model')

  actions:
    cancel: ->
      @get('model').destroyRecord().then =>
        @send('closeModal')
        @set('model', null)

    save: ->
      category = @get('model')
      project = @get('project')

      category.set('project', project)
      category.save().then =>
        project.get('categories').addObject(category)
        project.save().then =>
          @send('closeModal')
          @set('model', null)

`export default NewCategoryModalController;`