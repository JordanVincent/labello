`import Ember from "ember";`

ProjectIndexRoute = Ember.Route.extend

  actions:
    deleteDocument: (doc) ->
      doc.destroyRecord()

`export default ProjectIndexRoute`