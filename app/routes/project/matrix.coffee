`import Ember from "ember";`

ProjectMatrixRoute = Ember.Route.extend
  model: (params) ->
    @modelFor('project').get('labels')

`export default ProjectMatrixRoute`