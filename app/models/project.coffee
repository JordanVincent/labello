`import DS from "ember-data";`

Project = DS.Model.extend
  documents: DS.hasMany('document')
  labels: DS.hasMany('label')
  name: DS.attr()

Project.reopenClass
  FIXTURES: [
    { id: 1, name: 'The social impact of Uber', documents: [1], labels: [1,2]}
  ]

`export default Project;`