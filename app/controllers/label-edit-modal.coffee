`import Ember from 'ember';`

LabelEditModalController = Ember.ObjectController.extend
  newCategoryDisplayed: false
  creatingCategory: false
  oldCategory: null

  modelChanged: (->
    @set 'oldCategory', @get('model.category')
  ).observes('model')

  categoryAdded: (->
    return unless @get('creatingCategory')
    @set('creatingCategory', false)

    lastCategory = @get('model.project.categories.lastObject')
    @get('model').set('category', lastCategory)
    @set('newCategoryDisplayed', false)
  ).observes('model.project.categories.[]')

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
      @get('model.project').then (project) =>
        @set('creatingCategory', true)
        @send('createCategory', categoryName, project)

`export default LabelEditModalController;`