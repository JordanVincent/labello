`import Ember from 'ember';`

ColoredTextView = Em.View.extend
  tagName: 'span'
  templateName: 'views/colored-text'
  attributeBindings: ['style']

  style: (->
    'color:' + @get('color')
  ).property('color')

`export default ColoredTextView;`