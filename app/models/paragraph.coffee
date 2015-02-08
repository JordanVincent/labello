`import DS from "ember-data";`

Paragraph = DS.Model.extend
  document: DS.belongsTo('document')
  selections: DS.hasMany('selection', {async: true})

  text: DS.attr()
  tagName: DS.attr()

`export default Paragraph;`