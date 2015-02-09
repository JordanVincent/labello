`import Ember from "ember";`

DocumentRoute = Ember.Route.extend
  model: (params) ->
    @store.find('document', params.document_id)

  afterModel: (model) ->
    model.get('paragraphs').then (paragraphs) ->
      a = paragraphs.map (paragraph) ->
        paragraph.get('selections')
      Ember.RSVP.all(a)

  createSelection: (label, paragraph, startPosition, endPosition) ->
    selection = @store.createRecord 'selection',
      label: label
      paragraph: paragraph
      startPosition: startPosition
      endPosition: endPosition

    label.get('selections').addObject(selection)
    paragraph.get('selections').addObject(selection)

    selection.save().then ->
      Ember.RSVP.all [label.save(), paragraph.save()]

  deleteSelection: (selection) ->
    Ember.RSVP.all([
      selection.get('paragraph'),
      selection.get('label')
    ]).then (resolved) ->
      paragraph = resolved.objectAt(0)
      label = resolved.objectAt(1)
      paragraph.get('selections').removeObject(selection)
      label.get('selections').removeObject(selection)

      Ember.RSVP.all([paragraph.save(), label.save()]).then ->
        selection.destroyRecord()

  actions:
    createSelection: (label, paragraph, startPosition, endPosition) ->
      @createSelection(label, paragraph, startPosition, endPosition)

    createLabel: (labelName, paragraph, startPosition, endPosition) ->
      project = @controllerFor('document').get('content.project')
      label = @store.createRecord 'label',
        name: labelName
        project: project
        category: null
        color: Please.make_color()

      project.get('labels').addObject(label)

      label.save().then =>
        project.save().then =>
          @createSelection(label, paragraph, startPosition, endPosition)

    deleteLabel: (label) ->
      category = label.get('category')
      project = label.get('project')

      label.get('selections').then (selections) =>
        Ember.RSVP.all(selections.map (selection) =>
          @deleteSelection(selection) # Careful, self destructing array
        ).then ->
          category.get('labels').removeObject(label) if category
          project.get('labels').removeObject(label)

          promises = [project.save()]
          promises.addObject(category.save()) if category

          Ember.RSVP.all(promises).then ->
            label.destroyRecord()

    deleteSelection: (selection) ->
      @deleteSelection(selection)

`export default DocumentRoute`