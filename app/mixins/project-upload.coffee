`import Ember from 'ember';`

ProjectUpload = Ember.Mixin.create

  uploadProject: (json) ->
    @prefixJson(json).then ->
      console.log(json)

  # Private
  prefixJson: (json) ->
    prefix = ''
    projectId = Object.keys(json.project.records)[0]
    modelNames = ['project', 'document', 'label', 'category', 'paragraph', 'selection']

    @availablePrefix(projectId, 0).then (prefix) =>
      console.log prefix

      modelNames.forEach (modelName) =>

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
    newId = projectId + counter

    @store.find('project', newId).then (project) =>
      counter++
      @availablePrefix(projectId, counter).then ->
        deferred.resolve(newId)
    .catch ->
      deferred.resolve(newId)

    deferred.promise

  modelRelationships: (modelName) ->
    model = @store.modelFor(modelName)
    Ember.get(model, 'relationshipsByName')



`export default ProjectUpload;`