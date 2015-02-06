`import DS from "ember-data";`

Document = DS.Model.extend
  project: DS.belongsTo('project')
  paragraphs: DS.hasMany('paragraph', {async: true})
  text: DS.attr()
  title: DS.attr()

Document.reopenClass
  FIXTURES: [
    { id: 1, project: 1, title: 'History of Seattle', paragraphs: [1,2,3,4] }
  ]

`export default Document;`