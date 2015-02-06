`import Ember from 'ember';`
`import config from './config/environment';`

Router = Ember.Router.extend
  location: config.locationType

Router.map ->
  @resource 'projects', {path: '/'}
  @resource 'project', {path: 'projects/:project_id'}, ->
    @route 'newDocument'
    @resource 'labels', ->
      @resource 'label', {path: ':label_id'}, ->
        @resource 'selection', {path: 'selection/:selection_id'}
  @resource 'document', {path: 'documents/:document_id'}

`export default Router;`
