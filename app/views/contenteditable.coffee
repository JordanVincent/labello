`import Ember from 'ember';`

ContenteditableView = Em.View.extend
  tagName: 'div'
  classNames: ['contenteditable']
  attributeBindings: ['contenteditable']
  editable: true
  isUserTyping: false
  plaintext: false

  contenteditable: (->
    editable = @get('editable')
    if editable then 'true' else undefined
  ).property('editable')

  processValue: ->
    if !@get('isUserTyping') and @get('value')
      return @setContent()

  valueObserver: (->
    Ember.run.once this, 'processValue'
  ).observes('value', 'isUserTyping')

  didInsertElement: ->
    @setContent()

  focusOut: ->
    @set 'isUserTyping', false

  keyDown: (event) ->
    if !event.metaKey
      return @set('isUserTyping', true)

  keyUp: (event) ->
    if @get('plaintext')
      @set 'value', @$().text()
    else
      @set 'value', @$().html()

  render: (buffer) ->
    buffer.push @get('value')

  setContent: ->
    @$().html @get('value')


`export default ContenteditableView;`