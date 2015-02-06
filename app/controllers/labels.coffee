`import Ember from 'ember';`

LabelsController = Ember.ArrayController.extend
  singleLabels: Ember.computed.filterBy('content','category', null)

  actions:
    deleteCategory: (category) ->
      Ember.RSVP.all( category.get('labels').map (label) ->
        label.set('category', null)
        label.save()
      ).then ->
        project = category.get('project')
        project.get('categories').removeObject(category)
        project.save().then ->
          category.destroyRecord()


`export default LabelsController;`