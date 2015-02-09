`import Ember from "ember";`

ProjectIndexRoute = Ember.Route.extend

  actions:
    deleteDocument: (doc) ->
      doc.destroyRecordAndRelations()

    saveProject: ->
      @modelFor('project').save()

`export default ProjectIndexRoute`