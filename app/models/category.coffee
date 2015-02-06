`import DS from "ember-data";`

Category = DS.Model.extend
  project: DS.belongsTo('project')
  labels: DS.hasMany('label', {async: true})
  name: DS.attr()

`export default Category;`