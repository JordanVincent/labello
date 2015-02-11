`import DS from "ember-data";`
`import Ember from "ember";`

MyStore = DS.Store.extend()

MyStoreInitializer =
  name: 'my-store'
  initialize: (container, application) ->
    application.register('store:my', MyStore)
    application.inject('route', 'myStore', 'store:my')

`export default MyStoreInitializer;`