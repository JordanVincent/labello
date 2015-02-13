`import Ember from 'ember';`

ProjectToCsv = Ember.Mixin.create
  projectToCSV: (project) ->
    project.get('labels').then (labels) =>
      Ember.RSVP.all(labels.map (label) ->
        label.get('selections').then (selections) ->
          Ember.RSVP.all selections.map (selection) ->
            selection.toCsv()
      ).then (labelsSelectionsCVS) =>
        flat = []
        labelsSelectionsCVS.forEach (labelSelectionsCVS) ->
          flat.pushObjects(labelSelectionsCVS)
        new CSV(flat, {header: @csvHeaders()})

`export default ProjectToCsv;`