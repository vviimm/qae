window.AutocompleteQuestion =
  init: ->
    $(".js-autocomplete-multiple-boxes").each ->
      $(this).select2
        tags: true

      $(this).select2("val", $(this).data("selectedValue").split(", "))
