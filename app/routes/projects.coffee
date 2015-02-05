`import Ember from "ember";`

ProjectsRoute = Ember.Route.extend
  model: (params) ->
    @store.find('project')

  actions:
    new: ->
      project = @store.createRecord('project', { name: 'Untilted Project'})
      project.save().then =>
        @transitionTo('project', project)

`export default ProjectsRoute`