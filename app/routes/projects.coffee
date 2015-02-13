`import Ember from "ember";`
`import ProjectUpload from '../mixins/project-upload';`

ProjectsRoute = Ember.Route.extend ProjectUpload,
  model: (params) ->
    @store.find('project')

  actions:
    newProject: ->
      project = @store.createRecord('project', { name: 'Untilted Project'})
      project.save().then =>
        @transitionTo('project', project)

    deleteProject: (project) ->
      project.destroyRecordAndRelations()

    uploadProject: ->
      @send 'openModal', 'project-upload-modal'

    loadProjectFromJson: (json) ->
      @uploadProject(json).then (project) =>
        @send('closeModal')
        @controllerFor('project-upload-modal').set('model', null)
        @transitionTo('project', project)

`export default ProjectsRoute`