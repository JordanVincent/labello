`import DS from "ember-data";`

Project = DS.Model.extend
  documents: DS.hasMany('document', {async: true})
  categories: DS.hasMany('category', {async: true})
  labels: DS.hasMany('label', {async: true})
  name: DS.attr()

`export default Project;`