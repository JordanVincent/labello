`import Ember from "ember";`

ProjectsRoute = Ember.Route.extend
  model: (params) ->
    @store.find('project')

  actions:
    newProject: ->
      project = @store.createRecord('project', { name: 'Untilted Project'})
      project.save().then =>
        @transitionTo('project', project)

    deleteProject: (project) ->
      project.destroyRecordAndRelations()

`export default ProjectsRoute`