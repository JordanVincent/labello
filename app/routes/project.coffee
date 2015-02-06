`import Ember from "ember";`

ProjectRoute = Ember.Route.extend
  model: (params) ->
    @store.find('project', params.project_id)

  afterModel: (model) ->
    model.get('labels')

`export default ProjectRoute`