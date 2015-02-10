`import Ember from "ember";`

ProjectRoute = Ember.Route.extend
  model: (params) ->
    @store.find('project', params.project_id)

  afterModel: (model) ->
    model.get('labels')

  csvHeaders: ->
    ["Category","Label","Document","Selection"]

  downloadCSV: (fileName, csv) ->
    a = document.createElement('a')
    a.href = 'data:attachment/csv;charset=utf-8,' + encodeURIComponent(csv)
    a.target = '_blank'
    a.download = "#{fileName}.csv"

    document.body.appendChild(a)
    a.click()

  projectToCSV: (project) ->
    project.get('labels').then (labels) =>
      console.log(labels.get('length'))
      Ember.RSVP.all(labels.map (label) ->
        label.get('selections').then (selections) ->
          Ember.RSVP.all selections.map (selection) ->
            selection.toCsv()
      ).then (labelsSelectionsCVS) =>
        flat = []
        labelsSelectionsCVS.forEach (labelSelectionsCVS) ->
          flat.pushObjects(labelSelectionsCVS)
        new CSV(flat, {header: @csvHeaders()})

  actions:
    exportProject: ->
      project = @modelFor('project')
      @projectToCSV(project).then (csv) =>
        csvString = csv.encode()
        name = project.get('name')
        @downloadCSV(name, csvString)

`export default ProjectRoute`