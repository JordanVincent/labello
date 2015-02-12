`import Ember from "ember";`

SelectionRoute = Ember.Route.extend
  model: (params) ->
    @store.find('selection', params.selection_id)

  afterModel: (model) ->
    model.get('paragraph')

`export default SelectionRoute`