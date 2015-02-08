`import DS from "ember-data";`

# ApplicationSerializer = DS.LSSerializer.extend()

`var ApplicationSerializer = DS.JSONSerializer.extend({

  serializeHasMany: function(record, json, relationship) {
    var key = relationship.key;
    var payloadKey = this.keyForRelationship ? this.keyForRelationship(key, "hasMany") : key;
    var relationshipType = record.constructor.determineRelationshipType(relationship);

    if (relationshipType === 'manyToNone' ||
        relationshipType === 'manyToMany' ||
        relationshipType === 'manyToOne') {
      json[payloadKey] = record.get(key).mapBy('id');
      // TODO support for polymorphic manyToNone and manyToMany relationships
    }
  }
});`

# Issue
# https://github.com/kurko/ember-localstorage-adapter/issues/90

`export default ApplicationSerializer;`