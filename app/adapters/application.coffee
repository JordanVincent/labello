`import DS from "ember-data";`

# ApplicationAdapter = DS.FixtureAdapter;

# LocalStorage adapter
ApplicationAdapter = DS.LSAdapter.extend
  namespace: 'labello'

`export default ApplicationAdapter;`