window.CkeditorQaeForm =
  init: ->
    elements = CKEDITOR.document.find('.js-ckeditor')
    i = 0

    while element = elements.getItem(i++)
      CKEDITOR.replace element,
        toolbar: 'mini'
        height: 200
