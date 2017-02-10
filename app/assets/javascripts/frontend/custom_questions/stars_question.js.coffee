window.StarsQuestion =
  init: ->
    $('.js-stars-rating-question').each ->
      $(this).rateYo
        rating: $(this).next().val() || 5
        fullStar: true

      $(this).rateYo().on 'rateyo.set', (e, data) ->
        $(this).next().val(data.rating)

