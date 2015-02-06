`import Ember from "ember";`

SelectionRoute = Ember.Route.extend
  model: (params) ->
    @store.find('selection', params.selection_id)

`export default SelectionRoute`