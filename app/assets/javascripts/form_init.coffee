$(document).on 'turbolinks:load', ->
  $('.editor').wysihtml5
    toolbar:
      fa: true
      html: true
    locale: "de-DE"

  $('input.date').each (i, input) ->
    $input = $(input)
    date = $input.val()
    if date isnt ''
      [year, month, day] = date.split('-')
      $input.val [day, month, year].join('.')

    startView = $input.data().startView or 0
    $input.datepicker
      format: 'dd.mm.yyyy'
      startView: startView
      language: "de"
      todayHighlight: true
      autoclose: true
      zIndexOffset: 1151

  $('[autofocus]').focus()

  $(".select2").each (i, input) ->
    $input = $(input)
    placeholder = $input.data().placeholder
    $input.select2
      width: '100%'
      theme: "bootstrap"
      placeholder: placeholder
