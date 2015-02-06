`import Ember from "ember";`

ProjectIndexRoute = Ember.Route.extend

  actions:
    deleteDocument: (doc) ->
      doc.get('paragraphs').then (paragraphs) ->
        Ember.RSVP.all(paragraphs.map (paragraph) ->
          (paragraph.get('selections').then (selections) ->
            Ember.RSVP.all( selections.map (selection) ->
              label = selection.get('label')
              label.get('selections').removeObject(selection)
              label.save().then ->
                selection.destroyRecord()
            )
          ).then ->
            paragraph.destroyRecord()
        ).then ->
          doc.destroyRecord()

    saveProject: ->
      @modelFor('project').save()

`export default ProjectIndexRoute`