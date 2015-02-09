`import Ember from 'ember';`

LabelEditModalController = Ember.ObjectController.extend
  newCategoryDisplayed: false

  modelChanged: (->
    @set 'oldCategory', @get('category')
  ).observes('category')

  categoryAdded: (->
    lastCategory = @get('project.categories.lastObject')
    @get('model').set('category', lastCategory)
    @set('newCategoryDisplayed', false)
  ).observes('project.categories.[]')

  actions:
    cancel: ->
      label = @get('model')
      label.rollback()
      if @get('oldCategory')
        @get('oldCategory').get('labels').addObject(label)
      else if label.get('category')
        label.get('category.labels').removeObject(label)

      label.save().then =>
        @send('closeModal')

    save: ->
      @get('model').save().then =>
        @send('closeModal')

    showNewCategory: ->
      @set('newCategoryDisplayed', true)

    createNewCategory: (categoryName) ->
      @get('project').then (project) =>
        @send('createCategory', categoryName, project)

`export default LabelEditModalController;`