handle_comments = ->  
  commentId = $('.question_comments').data('commentId')  
  PrivatePub.subscribe commentId, (data, channel) ->         
    if data != undefined             
      res = $.parseJSON(data.comment_res.comment)
      result = JST["templates/create_comment"]
        user_name: data.comment_res.user 
        comment_body: res.body 
        comment_id: res.id      
      $('.comments_list').append(result)             
      $('.comments_error').html("")  
      $('.new_comment').find('#comment_body').val('')

      

$(document).ready(handle_comments)||$(document).on('page:load', handle_comments)||$(document).on('page:update', handle_comments)