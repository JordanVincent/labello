`import Ember from 'ember';`

DocumentController = Ember.ObjectController.extend
  selectedSelection: null

  scrollToElement: ($elem) ->
    elemOffset = $elem.offset().top
    offset = $('.text-selection').offset().top
    x = elemOffset - offset

    $('.paragraphs-pane').scrollTop(x)

  actions:
    editLabel: (label) ->
      @send 'openModal', 'label-edit-modal', label

    moveSelection: (selection) ->
      @send 'openModal', 'selection-move-modal', selection

    selectSelection: (selection) ->
      $elem = $('#' + selection.get('id'))
      return if Ember.isBlank($elem);
      @set('selectedSelection', selection)
      @scrollToElement($elem)

`export default DocumentController;`