`import DS from "ember-data";`

Selection = DS.Model.extend
  label: DS.belongsTo('label', {async: true})
  paragraph: DS.belongsTo('paragraph', {async: true})

  startPosition: DS.attr()
  endPosition: DS.attr()

  text: ( ->
    @get('paragraph.text').slice(@get('startPosition'), @get('endPosition'))
  ).property('paragraph','paragraph.text', 'startPosition', 'endPosition')

Selection.reopenClass
  FIXTURES: [
    { id: 1, paragraph: 1, label: 1, startPosition: 10, endPosition: 30}
    { id: 2, paragraph: 2, label: 1, startPosition: 0, endPosition: 50}
    { id: 3, paragraph: 2, label: 2, startPosition: 60, endPosition: 180}
    { id: 4, paragraph: 3, label: 2, startPosition: 5, endPosition: 35}
  ]

`export default Selection;`