`import DS from "ember-data";`

Document = DS.Model.extend
  project: DS.belongsTo('project')
  paragraphs: DS.hasMany('paragraph', {async: true})
  title: DS.attr()

  text: null #temporary

`export default Document;`