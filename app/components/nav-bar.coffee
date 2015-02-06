`import Ember from 'ember';`

NavBar = Ember.Component.extend

  actions:
    exportProject: ->
      @sendAction('exportProject')

`export default NavBar;`