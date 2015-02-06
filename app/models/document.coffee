`import DS from "ember-data";`

Document = DS.Model.extend
  project: DS.belongsTo('project')
  paragraphs: DS.hasMany('paragraph', {async: true})
  text: DS.attr()
  title: DS.attr()

`export default Document;`