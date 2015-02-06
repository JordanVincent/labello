`import Ember from "ember";`

LabelRoute = Ember.Route.extend
  model: (params) ->
    @store.find('label', params.label_id)

  afterModel: (model) ->
    model.get('selections')

`export default LabelRoute`