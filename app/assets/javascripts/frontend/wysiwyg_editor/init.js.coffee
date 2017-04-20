window.CkeditorQaeForm =
  init: ->
    CkeditorQaeForm.config()
    CkeditorQaeForm.initTextAreas()

  config: ->
    CKEDITOR.editorConfig = (config) ->
      config.toolbar_mini = [
        {
          name: 'clipboard'
          items: [
            'Cut'
            'Copy'
            'PasteText'
            '-'
            'Undo'
            'Redo'
          ]
        }
        {
          name: 'links'
          items: [
            'Link'
            'Unlink'
          ]
        }
        {
          name: 'tools'
          items: [ 'Maximize' ]
        }
        {
          name: 'basicstyles'
          items: [
            'Bold'
            'Italic'
            '-'
            'RemoveFormat'
          ]
        }
        {
          name: 'paragraph'
          items: [
            'NumberedList'
            'BulletedList'
            '-'
            'Outdent'
            'Indent'
            '-'
            'JustifyLeft'
            'JustifyCenter'
            'JustifyRight'
            'JustifyBlock'
          ]
        }
      ]

      config.toolbar = 'mini'
      return

  initTextAreas: ->
    elements = CKEDITOR.document.find('.js-ckeditor')
    i = 0

    while element = elements.getItem(i++)
      CKEDITOR.replace element,
        toolbar: 'mini'
        height: 200

  triggerUpdate: ->
    for instance of CKEDITOR.instances
      CKEDITOR.instances[instance].updateElement()

  triggerChanged: ->
    for instance of CKEDITOR.instances
      old_value = $("\##{instance}").val()
      new_value = CKEDITOR.instances[instance].getData()

      if old_value != new_value
        raiseChangesFlag()
