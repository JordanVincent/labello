`import DS from "ember-data";`

Category = DS.Model.extend
  project: DS.belongsTo('project', {async: true})
  labels: DS.hasMany('label', {async: true})
  name: DS.attr()

  labelsSorting: ['name']
  sortedLabels: Ember.computed.sort('labels','labelsSorting')

  # We don't destroy labels
  destroyRecordAndRelations: ->
    Ember.RSVP.all(@get('labels').toArray().map (label) =>
      @get('labels').removeObject(label)
      label.save()
    ).then =>
      @get('project').then (project) =>
        project.get('categories').removeObject(@)

        project.save().then =>
          @destroyRecord()

`export default Category;`