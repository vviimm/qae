window.SliderQuestion =
  init: ->
    $(".js-slider-question").each ->

      slider_range = $(this).find('.js-slider-question-range')
      input = $(this).find('.js-slider-amount')

      slider_range.slider
        range: true
        min: input.data('min')
        max: input.data('max')
        values: SliderQuestion.getValues(input)
        slide: (event, ui) ->
          input.val('£' + ui.values[0] + ' - £' + ui.values[1])
          return

      initial_value = '£' + slider_range.slider('values', 0) + ' - £' + slider_range.slider('values', 1)
      input.val(initial_value)

  getValues: (input) ->
    value = input.data('value')

    if value.length > 0
      value.replace(/\£/g, '').split(' - ').map(Number)
    else
      [ input.data('min') + 10, input.data('max') - 10 ]
