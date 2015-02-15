`import Ember from 'ember';`

DocumentSelections = Ember.Component.extend

  documentSelectionsObs: (->
    @get('label.selections').then (selections) =>
      Ember.RSVP.all( selections.map (selection) =>
        selection.get('document').then (doc) =>
          selection if doc is @get('document')
      ).then (documentSelections) =>
        @set 'documentSelections', documentSelections.compact()
  ).observes('label', 'document').on('init')

`export default DocumentSelections;`