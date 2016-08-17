handle_comments = ->  
  $('.new_comment').bind 'ajax:success', (e, data, status, xhr) -> 
    $('.comments_error').html('')
    res = $.parseJSON(xhr.responseText)
    result = JST["templates/create_comment"]
      user_name: res.user_name
      comment_body: res.comment.body
      custom_id: res.type + '_comment_' + res.comment.id          
    $('.comments_list').append(result) 
    $('.new_comment').find('#comment_body').val('')
  .bind 'ajax:error', (e, xhr, status, error) ->
    $('.comments_error').html('')
    res = xhr.responseJSON.errors
    $('.comments_error').html('<p>' + res + '</p>')

$(document).ready(handle_comments)||$(document).on('page:load', handle_comments)||$(document).on('page:update', handle_comments)