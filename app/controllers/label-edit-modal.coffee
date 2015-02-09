`import Ember from 'ember';`

LabelEditModalController = Ember.ObjectController.extend
  newCategoryDisplayed: false
  newCategoryName: null
  creatingCategory: false

  oldCategory: null
  newCategory: null

  modelChanged: (->
    return unless @get('model')
    @get('model.category').then (category) =>
      @set 'oldCategory', category
      @set 'newCategory', category
  ).observes('model')

  categoryAdded: (->
    return unless @get('creatingCategory')
    @set('creatingCategory', false)

    lastCategory = @get('model.project.categories.lastObject')
    @get('model').set('category', lastCategory)
    @set('newCategory', lastCategory)

    @set('newCategoryDisplayed', false)
  ).observes('model.project.categories.[]')

  saveNewCategory: ->
    label = @get('model')
    @get('newCategory.labels').addObject(label)
    @get('newCategory').save()

  saveOldCategory: ->
    label = @get('model')
    @get('oldCategory.labels').removeObject(label)
    @get('oldCategory').save()

  closeModal: ->
    @send('closeModal')
    @set('newCategoryDisplayed', false)
    @set('newCategoryName', null)
    @set('model', null)

  actions:
    cancel: ->
      label = @get('model')
      label.rollback()
      if @get('oldCategory')
        @get('oldCategory.labels').addObject(label)

      label.save().then =>
        @closeModal()

    save: ->
      @get('model').save().then =>
        promisse = Ember.RSVP.resolve()

        if @get('oldCategory')
          promisse = @saveOldCategory().then =>
            @saveNewCategory() if @get('newCategory')
        else if @get('newCategory')
          promisse = @saveNewCategory()

        promisse.then =>
          @closeModal()

    showNewCategory: ->
      @set('newCategoryDisplayed', true)

    createNewCategory: (categoryName) ->
      @get('model.project').then (project) =>
        @set('creatingCategory', true)
        @send('createCategory', categoryName, project)

`export default LabelEditModalController;`