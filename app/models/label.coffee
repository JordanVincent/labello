`import DS from "ember-data";`

Label = DS.Model.extend
  project: DS.belongsTo('project', {async: true})
  category: DS.belongsTo('category', {async: true}) # hasOne
  selections: DS.hasMany('selection', {async: true})

  name: DS.attr()
  color: DS.attr()

  fullName: (->
    categoryName = @get('category.name')
    if categoryName then categoryName + ' / ' + @get('name') else @get('name')
  ).property('name', 'category.name')

  destroyRecordAndRelations: ->
    Ember.RSVP.all([
      @get('category')
      @get('project')
      @get('selections')
    ]).then (resolved) =>
      category = resolved.objectAt(0)
      project = resolved.objectAt(1)
      selections = resolved.objectAt(2)

      Ember.RSVP.all(selections.toArray().map (selection) ->
        selection.destroyRecordAndRelations()
      ).then =>
        category.get('labels').removeObject(@) if category
        project.get('labels').removeObject(@)

        promises = [project.save()]
        promises.addObject(category.save()) if category

        Ember.RSVP.all(promises).then =>
          @destroyRecord()

`export default Label;`