`import Ember from 'ember';`
`import config from './config/environment';`
`import googlePageview from './mixins/google-pageview';`

Router = Ember.Router.extend googlePageview,
  location: config.locationType

Router.map ->
  @resource 'projects', {path: '/'}
  @resource 'project', {path: 'projects/:project_id'}, ->
    @route 'newDocument'
    @resource 'document', {path: 'documents/:document_id'}
    @resource 'labels', ->
      @resource 'label', {path: ':label_id'}, ->
        @resource 'selection', {path: 'selection/:selection_id'}

`export default Router;`
