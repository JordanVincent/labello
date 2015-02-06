`import Ember from "ember";`

LabelRoute = Ember.Route.extend
  model: (params) ->
    @store.find('label', params.label_id)

  afterModel: (model) ->
    model.get('selections').then (selections) ->
      Ember.RSVP.all selections.map (selection) ->
        selection.get('paragraph')

`export default LabelRoute`