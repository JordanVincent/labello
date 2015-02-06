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
      Ember.RSVP.all(labels.map (label) ->
        label.get('selections').then (selections) ->
          selections.map (selection) ->
            selection.get('csv')
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
        console.log csvString
        name = project.get('name')
        @downloadCSV(name, csvString)

`export default ProjectRoute`