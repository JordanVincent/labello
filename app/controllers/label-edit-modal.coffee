`import Ember from 'ember';`

LabelEditModalController = Ember.ObjectController.extend
  newCategoryDisplayed: false

  modelChanged: (->
    @set 'oldCategory', @get('model.category')
  ).observes('model')

  categoryAdded: (->
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
        label.get('category').get('labels').removeObject(label)

      label.save().then =>
        @send('closeModal')

    save: ->
      @get('model').save().then =>
        @send('closeModal')

    showNewCategory: ->
      @set('newCategoryDisplayed', true)

    createNewCategory: (categoryName) ->
      @send('createCategory', categoryName, @get('model.project'))

`export default LabelEditModalController;`