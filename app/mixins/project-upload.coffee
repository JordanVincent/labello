`import Ember from 'ember';`

ProjectUpload = Ember.Mixin.create

  uploadProject: (json) ->
    @prefixJson(json).then =>
      console.log(json)
      # @store.pushPayload(json)
      @createRecords(json)


  createRecords: (json) ->
    @getModelNames().forEach (modelName) =>
      return unless json[modelName]
      records = json[modelName].records
      for key, jsonRecord of records
        @createRecord(modelName, jsonRecord)

  createRecord: (modelName, jsonRecord) ->
    type = @store.modelFor(modelName)
    record = @store.push(type, jsonRecord)
    console.log record
    record.save()


  # Private
  prefixJson: (json) ->
    projectId = Object.keys(json.project.records)[0]

    @availablePrefix(projectId, 0).then (prefix) =>
      console.log prefix

      @getModelNames().forEach (modelName) =>

        return unless json[modelName]
        records = json[modelName].records
        buffer = {}
        for key, jsonRecord of records
          buffer[@addPrefix(prefix,key)] = @prefixModel(modelName, jsonRecord, prefix)

        json[modelName].records = buffer


  addPrefix: (prefix, id) ->
    prefix + '-' + id

  prefixModel: (modelName, json, prefix) ->
    json.id = @addPrefix(prefix, json.id) # prefix id
    relationships = @modelRelationships(modelName)

    relationships.forEach (relationship) =>
      typeKey = relationship.type.typeKey
      newRlationshipIds = null
      relationshipIds = json[relationship.key]

      return unless relationshipIds
      if relationship.kind is 'belongsTo'
        newRlationshipIds = @addPrefix(prefix, relationshipIds)
      else
        newRlationshipIds = relationshipIds.map (relationshipId) =>
          @addPrefix(prefix, relationshipId)

      json[relationship.key] = newRlationshipIds
    json


  availablePrefix: (projectId, counter) ->
    deferred = Ember.RSVP.defer()
    prefix = projectId + counter
    console.log('prefix', prefix)
    @store.find('project', @addPrefix(prefix, projectId)).then (project) =>
      counter++
      @availablePrefix(projectId, counter).then (prefix) ->
        deferred.resolve(prefix)
    .catch ->
      deferred.resolve(prefix)

    deferred.promise

  modelRelationships: (modelName) ->
    model = @store.modelFor(modelName)
    Ember.get(model, 'relationshipsByName')

  getModelNames: ->
    ['project', 'document', 'label', 'category', 'paragraph', 'selection']



`export default ProjectUpload;`