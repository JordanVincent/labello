`import DS from "ember-data";`

Label = DS.Model.extend
  project: DS.belongsTo('project', {async: true})
  category: DS.belongsTo('category', {async: true})
  selections: DS.hasMany('selection', {async: true})

  name: DS.attr()
  color: DS.attr()

`export default Label;`