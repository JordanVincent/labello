`import Ember from "ember";`

ProjectIndexRoute = Ember.Route.extend

  actions:
    deleteDocument: (doc) ->
      doc.destroyRecordAndRelations()

    editDocument: (doc) ->
      @send 'openModal', 'document-edit-modal', doc

    saveProject: ->
      @modelFor('project').save()

`export default ProjectIndexRoute`