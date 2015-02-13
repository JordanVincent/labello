`import Ember from "ember";`
`import ProjectDownload from '../mixins/project-download';`
`import ProjectUpload from '../mixins/project-upload';`

ProjectRoute = Ember.Route.extend ProjectDownload, ProjectUpload,
  model: (params) ->
    @store.find('project', params.project_id)

  afterModel: (model) ->
    model.get('labels')

  csvHeaders: ->
    ["Category","Label","Document","Selection"]

  downloadFile: (fileName, fileType, data, fileExtension) ->
    fileExtension = fileType unless fileExtension
    a = document.createElement('a')
    a.href = 'data:attachment/' + fileType + ';charset=utf-8,' + encodeURIComponent(data)
    a.target = '_blank'
    a.download = "#{fileName}.#{fileExtension}"

    document.body.appendChild(a)
    a.click()

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

  actions:
    exportProject: ->
      project = @modelFor('project')
      @projectToCSV(project).then (csv) =>
        csvString = csv.encode()
        name = project.get('name')
        @downloadFile(name, 'csv', csvString)

    downloadProject: ->
      project = @modelFor('project')
      json = @downloadProject(project)
      console.log json
      name = project.get('name')
      @downloadFile(name, 'json', JSON.stringify(json), 'lbo')
      # return @uploadProject(json)


`export default ProjectRoute`