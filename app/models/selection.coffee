`import DS from "ember-data";`

Selection = DS.Model.extend
  label: DS.belongsTo('label', {async: true})
  paragraph: DS.belongsTo('paragraph', {async: true})

  startPosition: DS.attr()
  endPosition: DS.attr()

  text: ( ->
    @get('paragraph.text').slice(@get('startPosition'), @get('endPosition'))
  ).property('paragraph.text', 'startPosition', 'endPosition')

`export default Selection;`