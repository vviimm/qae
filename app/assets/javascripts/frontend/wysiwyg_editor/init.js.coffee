window.CkeditorQaeForm =
  init: ->
    elements = CKEDITOR.document.find('.js-ckeditor')
    i = 0

    while element = elements.getItem(i++)
      CKEDITOR.replace element,
        toolbar: 'mini'
        height: 200

      CKEDITOR.on 'instanceCreated', (event) ->
        editor = event.editor
        element = editor.element

        editor.on 'configLoaded', ->
          editor.config.wordcount =
            maxWordCount: element.data('word-max')
