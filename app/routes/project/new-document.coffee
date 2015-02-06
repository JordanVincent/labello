`import Ember from "ember";`

ProjectNewDocumentRoute = Ember.Route.extend
  model: (params) ->
    @store.createRecord('document', { text: '', title: 'Untilted Document'})

  generateParagraphs: (doc) ->
    text = '<div>' + doc.get('text') + '</div>'
    blocks = $(text).find('div, p, h1, h2, h3, h4, h5')

    paragraphs = []
    blocks.each (index, block) =>
      unless Ember.isBlank $(block).text()
        paragraphs.addObject @createParagraph doc, $(block)
    paragraphs

  createParagraph: (doc, $block) ->
    @store.createRecord 'paragraph',
      # tagName: $block.prop('tagName')
      tagName: 'p'
      text: $block.text()
      document: doc

  actions:
    save: (doc) ->
      paragraphs = @generateParagraphs(doc)

      project = @controllerFor('project').get('content')
      project.get('documents').addObject(doc)

      Ember.RSVP.all(paragraphs.map (paragraph) =>
        paragraph.save()
      ).then =>
        doc.save().then =>
          project.save().then =>
            @transitionTo('project')

`export default ProjectNewDocumentRoute`