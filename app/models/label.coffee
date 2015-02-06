`import DS from "ember-data";`

Label = DS.Model.extend
  project: DS.belongsTo('project', {async: true})
  selections: DS.hasMany('selection', {async: true})
  name: DS.attr()
  color: DS.attr()

Label.reopenClass
  FIXTURES: [
    { id: 1, name: 'Motivations', project: 1, color: '#CC1144', selections: [1,2]}
    { id: 2, name: 'Frustrations', project: 1, color: '#8855AA', selections: [3,4]}
  ]

`export default Label;`