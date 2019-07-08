charactersLeft = () ->
  MAX_LENGTH = 140
  $content = $('#micropost_content')
  $charsLeft = $('.characters-left span')

  () ->
    $charsLeft.text(MAX_LENGTH - $content.val().trim().length)

$(document).on 'turbolinks:load', () ->
  onContentChanged = charactersLeft()
  onContentChanged()
  $('#micropost_content').on 'input', onContentChanged
