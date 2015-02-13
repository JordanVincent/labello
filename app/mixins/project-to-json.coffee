`import Ember from 'ember';`

ProjectToJson = Ember.Mixin.create

  projectToJson: (project) ->
    extract = @initExtract()
    json = @accessJson()
    jsonProject = @copyJsonToExtract('project', project.get('id'), extract, json)

    relationships = @modelRelationships('project')

    # project
    @extractRelationships(relationships, jsonProject, extract, json)

    # documents
    @extractModel('document', extract, json)
    @extractModel('label', extract, json)

    extract

  # Private

  accessJson: ->
    namespace = @store.adapterFor('project').get('namespace')
    JSON.parse(localStorage[namespace])

  copyJsonToExtract: (modelName, recordId, extract, json) ->
    jsonStub = json[modelName].records[recordId]
    return unless jsonStub
    extract[modelName].records[recordId] = jsonStub

  modelRelationships: (modelName) ->
    model = @store.modelFor(modelName)
    Ember.get(model, 'relationshipsByName')

  extractModel: (modelName, extract, json) ->
    relationships = @modelRelationships(modelName)

    for modelId, record of extract[modelName].records
      @extractRelationships(relationships, record, extract, json)

  extractRelationships: (relationships, record, extract, json) ->
    relationships.forEach (relationship) =>
      typeKey = relationship.type.typeKey

      relationshipIds = record[relationship.key]
      relationshipIds = [relationshipIds] if relationship.kind is 'belongsTo'

      relationshipIds.forEach (relationshipId) =>
        @copyJsonToExtract(typeKey, relationshipId, extract, json)

  initExtract: ->
    extract = {}
    models = ['project', 'document', 'label', 'category', 'paragraph', 'selection']
    models.forEach (model) ->
      extract[model] =
        records: {}
    extract

`export default ProjectToJson;`