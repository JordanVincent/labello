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

  toCsv: ->
    Ember.RSVP.all([
      @get('label')
      @get('paragraph')
    ]).then (resolved) =>
      label = resolved.objectAt(0)
      paragraph = resolved.objectAt(1)

      paragraph.get('document').then (doc) =>
        label.get('category').then (category) =>
          categoryName = if category then category.get('name') else ''

          [
            categoryName
            label.get('name')
            doc.get('title')
            @get('text')
          ]

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