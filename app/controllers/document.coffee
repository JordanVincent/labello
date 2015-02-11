`import Ember from 'ember';`

DocumentController = Ember.ObjectController.extend
  selectedSelection: null

  scrollToElement: ($elem) ->
    elemOffset = $elem.offset().top
    offset = $('.text-selection').offset().top
    x = elemOffset - offset

    $('.paragraphs-pane').scrollTop(x)

  scrollToListElement: ($elem) ->
    elemOffset = $elem.offset().top
    offset = $('.labels-pane .inner').offset().top
    x = elemOffset - offset

    $('.labels-pane').scrollTop(x)

  actions:
    editLabel: (label) ->
      @send 'openModal', 'label-edit-modal', label

    moveSelection: (selection) ->
      @send 'openModal', 'selection-move-modal', selection

    # From the list
    selectSelection: (selection) ->
      $elem = $('.paragraphs-pane .selection-' + selection.get('id'))
      return if Ember.isBlank($elem);
      @set('selectedSelection', selection)
      @scrollToElement($($elem[0]))

    # From the text
    selectionSelected: (selection) ->
      $elem = $('.labels-pane .selection-' + selection.get('id'))
      return if Ember.isBlank($elem);
      @set('selectedSelection', selection)
      @scrollToListElement($($elem[0]))

`export default DocumentController;`