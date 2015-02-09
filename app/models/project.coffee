`import DS from "ember-data";`

Project = DS.Model.extend
  documents: DS.hasMany('document', {async: true})
  categories: DS.hasMany('category', {async: true})
  labels: DS.hasMany('label', {async: true})
  name: DS.attr()

  # TODO destroy labels and categories
  destroyRecordAndRelations: ->
    Ember.RSVP.all([
      @get('documents')
      @get('categories')
      @get('labels')
    ]).then (resolved) =>
      documents = resolved.objectAt(0)
      categories = resolved.objectAt(1)
      labels = resolved.objectAt(2)

    @get('documents').then (documents) =>
      Ember.RSVP.all(documents.toArray().map (doc) ->
        doc.destroyRecordAndRelations()
      ).then =>
        Ember.RSVP.all(labels.toArray().map (label) ->
          label.destroyRecordAndRelations()
        ).then =>
          Ember.RSVP.all(categories.toArray().map (category) ->
            category.destroyRecordAndRelations()
          ).then =>
            @destroyRecord()

`export default Project;`