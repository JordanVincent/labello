`import Ember from "ember";`
`import ProjectUpload from '../mixins/project-upload';`

ApplicationRoute = Ember.Route.extend ProjectUpload,

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
      @uploadProject(json).then (project) =>
        @send('closeModal')
        @controllerFor('project-upload-modal').set('model', null)
        @transitionTo('project', project)

`export default ApplicationRoute`