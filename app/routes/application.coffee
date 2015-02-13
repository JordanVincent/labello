`import Ember from "ember";`
`import JsonToProject from '../mixins/json-to-project';`

ApplicationRoute = Ember.Route.extend JsonToProject,

  actions:
    openModal: (modalName, model) ->
      @controllerFor(modalName).set('model', model)
      @render modalName,
        into: 'application'
        outlet: 'modal'

    closeModal: ->
      @disconnectOutlet
        outlet: 'modal'
        parentView: 'application'

    createCategory: (categoryName, project) ->
      category = @store.createRecord 'category',
        name: categoryName
        project: project

      project.get('categories').addObject(category)

      category.save().then ->
        project.save()

    uploadProject: ->
      @send 'openModal', 'project-upload-modal'

    loadProjectFromJson: (json) ->
      @jsonToProject(json).then (project) =>
        @send('closeModal')
        @controllerFor('project-upload-modal').set('model', null)
        @transitionTo('project', project)

`export default ApplicationRoute`