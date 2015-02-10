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

    newCategory: ->
      category = @store.createRecord('category')
      @send 'openModal', 'new-category-modal', category

    newLabel: ->
      label = @store.createRecord('label')
      @send 'openModal', 'new-label-modal', label

`export default LabelsRoute`