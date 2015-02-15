`import Ember from 'ember';`

ProjectMatrixController = Ember.ArrayController.extend
  needs: 'project'
  project: Ember.computed.alias('controllers.project.model')

  categories: Ember.computed.alias('project.sortedCategories')
  documents: Ember.computed.alias('project.documents')

  selectedIndex: null

  actions:
    selectLabel: (index) ->
      @set('selectedIndex', index)

`export default ProjectMatrixController;`