`import Ember from "ember";`

ApplicationRoute = Ember.Route.extend

  actions:
    openModal: (modalName, model) ->
      @controllerFor(modalName).set('model', model)
      @render modalName,
        into: 'application'
        outlet: 'modal'

    closeModal: ->
      @disconnectOutlet
        outlet: 'modal'
        parentView: 'application'

    createCategory: (categoryName, project) ->
      category = @store.createRecord 'category',
        name: categoryName
        project: project

      project.get('categories').addObject(category)

      category.save().then ->
        project.save()

`export default ApplicationRoute`