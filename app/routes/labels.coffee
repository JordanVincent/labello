`import Ember from "ember";`

LabelsRoute = Ember.Route.extend
  model: (params) ->
    @modelFor('project').get('labels')

  setupController: (controller, model) ->
    @_super(controller, model)

    controller.set 'categories', @modelFor('project').get('sortedCategories')

  actions:
    deleteCategory: (category) ->
      category.destroyRecordAndRelations()

`export default LabelsRoute`