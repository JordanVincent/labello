`import Ember from "ember";`

ProjectNewDocumentRoute = Ember.Route.extend
  model: (params) ->
    @store.createRecord('document')

  generateParagraphs: (doc) ->
    text = '<div>' + doc.get('text') + '</div>'
    blocks = $(text).find('div, p, h1, h2, h3, h4, h5')

    paragraphs = []
    blocks.each (index, block) =>
      paragraphs.addObject @createParagraph doc, $(block)
    paragraphs

  createParagraph: (doc, $block) ->
    @store.createRecord 'paragraph',
      tagName: $block.prop('tagName')
      text: $block.text()
      document: doc

  actions:
    save: (doc) ->
      paragraphs = @generateParagraphs(doc)
      console.log paragraphs
      project = @controllerFor('project').get('content')
      project.get('documents').addObject(doc)

      doc.save().then =>
        project.save().then =>
          @transitionTo('project')

`export default ProjectNewDocumentRoute`