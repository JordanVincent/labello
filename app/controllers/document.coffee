`import Ember from 'ember';`

DocumentController = Ember.ObjectController.extend
  selectedSelection: null

  scrollToElement: (container, $elem) ->
    elemOffset = $elem.offset().top
    offset = $("#{container} .inner").offset().top
    y = elemOffset - offset

    $(container).scrollTop(y)

  select: (container, selection) ->
    $elem = $(container + ' .selection-' + selection.get('id'))
    return if Ember.isBlank($elem);

    @set('selectedSelection', selection)
    @scrollToElement(container, $($elem[0]))

  actions:
    editLabel: (label) ->
      @send 'openModal', 'label-edit-modal', label

    moveSelection: (selection) ->
      @send 'openModal', 'selection-move-modal', selection

    # Selected from the list
    selectSelection: (selection) ->
      @select('.paragraphs-pane', selection)

    # Selected from the text
    selectionSelected: (selection) ->
      @select('.labels-pane', selection)

`export default DocumentController;`