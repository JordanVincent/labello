`import DS from "ember-data";`

Category = DS.Model.extend
  project: DS.belongsTo('project', {async: true})
  labels: DS.hasMany('label', {async: true})
  name: DS.attr()

  # We don't destroy labels
  destroyRecordAndRelations: ->
    Ember.RSVP.all(category.get('labels').map (label) ->
      label.set('category', null)
      label.save()
    ).then =>
      category.get('project').then (project) =>
        project.get('categories').removeObject(@)

        project.save().then =>
          @destroyRecord()

`export default Category;`