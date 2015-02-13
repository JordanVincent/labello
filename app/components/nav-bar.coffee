`import Ember from 'ember';`

NavBar = Ember.Component.extend

  actions:
    exportProject: ->
      @sendAction('exportProject')

    downloadProject: ->
      @sendAction('downloadProject')

    uploadProject: ->
      @sendAction('uploadProject')

`export default NavBar;`