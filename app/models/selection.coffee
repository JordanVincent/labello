`import DS from "ember-data";`

Selection = DS.Model.extend
  label: DS.belongsTo('label', {async: true})
  paragraph: DS.belongsTo('paragraph', {async: true})

  startPosition: DS.attr()
  endPosition: DS.attr()

  document: Ember.computed.alias('paragraph.document')

  text: ( ->
    return '' unless @get('paragraph.text')
    @get('paragraph.text').slice(@get('startPosition'), @get('endPosition'))
  ).property('paragraph', 'paragraph.text', 'startPosition', 'endPosition')

  csv: ( ->
    categoryName = @get('label.category.name')
    [
      (if categoryName then categoryName else ''),
      @get('label.name'),
      @get('paragraph.document.title'),
      @get('text')
    ]
  ).property('text', 'label.name', 'label.category.name', 'paragraph.document.title')

  destroyRecordAndRelations: ->
    Ember.RSVP.all([
      @get('paragraph')
      @get('label')
    ]).then (resolved) =>
      paragraph = resolved.objectAt(0)
      label = resolved.objectAt(1)

      paragraph.get('selections').removeObject(@)
      label.get('selections').removeObject(@)

      Ember.RSVP.all([paragraph.save(), label.save()]).then =>
        @destroyRecord()

`export default Selection;`