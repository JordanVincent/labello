`import DS from "ember-data";`

Label = DS.Model.extend
  project: DS.belongsTo('project')
  category: DS.belongsTo('category')
  selections: DS.hasMany('selection', {async: true})

  name: DS.attr()
  color: DS.attr()

`export default Label;`