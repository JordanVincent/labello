`import Ember from 'ember';`

LabelSelections = Ember.Component.extend
  classNames: ['label-row']
  attributeBindings: ['style']

  style: (->
    # /!\ few labels
    if @get('index') is @get('selectedIndex')
      'height: 50%; flex: none;'
    else if @get('index') is (@get('selectedIndex') - 1) or @get('index') is (@get('selectedIndex') + 1)
      'height: 10%; flex: none;'
    else if @get('index') is (@get('selectedIndex') - 2) or @get('index') is (@get('selectedIndex') + 2)
      'height: 5%; flex: none;'
  ).property('index', 'selectedIndex')

  # Todo on parent
  didInsertElement: ->
    @$().bind 'mousewheel', (event) =>
      ## FF?
      if (event.originalEvent.wheelDelta > 0 || event.originalEvent.detail < 0)
        @sendAction 'selectLabel', (@get('index') + 1)
      else
        @sendAction 'selectLabel', (@get('index') - 1)

  willRemoveElement: ->
    @$().unbind 'mousewheel'

  actions:
    click: ->
      console.log('azesfd')
      @sendAction 'selectLabel', @get('index')

`export default LabelSelections;`