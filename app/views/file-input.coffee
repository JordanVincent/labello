`import Ember from 'ember';`

FileInputView = Ember.TextField.extend
  type: 'file',
  attributeBindings: ['name', 'accept']

  change: (event) ->
    input = event.target

    if input.files and input.files[0]
      reader = new FileReader()

      reader.onload = =>
        fileToUpload = reader.result
        # @get('controller').set(@get('name'), fileToUpload)
        decodedFile = atob(fileToUpload.replace(/data:;base64,/, ''))
        @set('data', decodedFile)
      reader.readAsDataURL(input.files[0])

`export default FileInputView;`
