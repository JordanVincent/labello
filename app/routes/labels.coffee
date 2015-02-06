`import Ember from "ember";`

LabelsRoute = Ember.Route.extend
  model: (params) ->
    @modelFor('project').get('labels')

`export default LabelsRoute`