window.TypeOfGood =
  init: ->
    $(document).on "click", "fieldset[data-answer='type_of_good-select-type'] .selectable", (e) ->
      type_of_good = $("fieldset[data-answer='type_of_good-select-type'] .selectable.selected input[name='form[type_of_good]']").val()
      $(".qae-form-good-type").text(type_of_good)
