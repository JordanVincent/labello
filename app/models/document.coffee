`import DS from "ember-data";`

Document = DS.Model.extend
  project: DS.belongsTo('project', {async: true})
  paragraphs: DS.hasMany('paragraph', {async: true})
  title: DS.attr()

  text: null #temporary

  destroyRecordAndRelations: ->
    @get('paragraphs').then (paragraphs) =>
      Ember.RSVP.all(paragraphs.toArray().map (paragraph) ->
        paragraph.destroyRecordAndRelations()
      ).then =>
        @get('project').then (project) =>
          project.get('documents').removeObject(@)
          project.save().then =>
            @destroyRecord()

`export default Document;`