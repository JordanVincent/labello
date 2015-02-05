`import Ember from "ember";`

DocumentRoute = Ember.Route.extend
  model: (params) ->
    @store.find('document', params.document_id)

  afterModel: (model) ->
    model.get('paragraphs')

  createSelection: (label, paragraph, startPosition, endPosition) ->
      selection = @store.createRecord 'selection',
        label: label
        paragraph: paragraph
        startPosition: startPosition
        endPosition: endPosition

      console.log selection

      label.get('selections').addObject(selection)
      paragraph.get('selections').addObject(selection)

      # TODO save()

  actions:
    createSelection: (label, paragraph, startPosition, endPosition) ->
      @createSelection(label, paragraph, startPosition, endPosition)

    createLabel: (labelName, paragraph, startPosition, endPosition) ->
      console.log labelName
      project = @controllerFor('document').get('content.project')
      label = @store.createRecord 'label',
        name: labelName
        project: project

      project.get('labels').addObject(label)
      @createSelection(label, paragraph, startPosition, endPosition)

      # TODO save()

    deleteSelection: (selection) ->
      selection.destroyRecord()

`export default DocumentRoute`