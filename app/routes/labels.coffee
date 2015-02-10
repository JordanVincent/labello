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

    editCategory: (category) ->
      @send 'openModal', 'category-edit-modal', category

    newCategory: ->
      category = @store.createRecord('category')
      @send 'openModal', 'category-new-modal', category

    newLabel: ->
      label = @store.createRecord('label')
      @send 'openModal', 'label-new-modal', label

`export default LabelsRoute`