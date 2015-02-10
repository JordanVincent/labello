`import Ember from "ember";`

DocumentRoute = Ember.Route.extend
  model: (params) ->
    @store.find('document', params.document_id)

  afterModel: (model) ->
    model.get('paragraphs').then (paragraphs) ->
      Ember.RSVP.all paragraphs.map (paragraph) ->
        paragraph.get('selections')

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

  actions:
    createSelection: (label, paragraph, startPosition, endPosition) ->
      @createSelection(label, paragraph, startPosition, endPosition)

    createLabel: (labelName, paragraph, startPosition, endPosition) ->
      project = @modelFor('project')
      label = @store.createRecord 'label',
        name: labelName
        project: project
        color: Please.make_color()

      project.get('labels').addObject(label)

      label.save().then =>
        project.save().then =>
          @createSelection(label, paragraph, startPosition, endPosition)

    deleteLabel: (label) ->
      label.destroyRecordAndRelations()

    deleteSelection: (selection) ->
      selection.destroyRecordAndRelations()

`export default DocumentRoute`