`import Ember from "ember";`
`import ProjectToJson from '../mixins/project-to-json';`
`import ProjectToCsv from '../mixins/project-to-csv';`

ProjectRoute = Ember.Route.extend ProjectToJson, ProjectToCsv,
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

  actions:
    exportProject: ->
      project = @modelFor('project')
      @projectToCSV(project).then (csv) =>
        csvString = csv.encode()
        name = project.get('name')
        @downloadFile(name, 'csv', csvString)

    downloadProject: ->
      project = @modelFor('project')
      json = @projectToJson(project)
      name = project.get('name')
      @downloadFile(name, 'json', JSON.stringify(json), 'lbo')


`export default ProjectRoute`