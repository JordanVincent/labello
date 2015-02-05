`import DS from "ember-data";`

Project = DS.Model.extend
  documents: DS.hasMany('document', {async: true})
  labels: DS.hasMany('label', {async: true})
  name: DS.attr()

Project.reopenClass
  FIXTURES: [
    { id: 1, name: 'The social impact of Uber', documents: [1], labels: [1,2]}
  ]

`export default Project;`