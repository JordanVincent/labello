`import DS from "ember-data";`

Paragraph = DS.Model.extend
  document: DS.belongsTo('document', {async: true})
  selections: DS.hasMany('selection', {async: true})

  text: DS.attr()
  tagName: DS.attr()

  destroyRecordAndRelations: ->
    @get('selections').then (selections) =>
      Ember.RSVP.all(selections.toArray().map (selection) ->
        selection.destroyRecordAndRelations()
      ).then =>
        @destroyRecord()

`export default Paragraph;`