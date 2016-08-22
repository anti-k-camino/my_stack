handle_comments = ->  
  PrivatePub.subscribe '/comments', (data, channel) ->         
    if data != undefined             
      res = $.parseJSON(data.comment_res.comment)
      user = $.parseJSON(data.comment_res.user)
      result = JST["templates/create_comment"]
        user_name: user.name 
        comment_body: res.body 
        comment_id: res.id
        comment_type: data.comment_res.type       
      list_selector = '#' + data.comment_res.type + '_' + data.comment_res.type_id + '_list'         
      $(list_selector).append(result)             
      $('.comments_error').html("")  
      $('.new_comment').find('#comment_body').val('') 
      if(gon.user.id is user.id)        
        selector = '#' + data.comment_res.type  + '_comment_' + res.id               
        deletable_result = JST["templates/delete_comment"]
          comment_id: res.id               
        $(selector).append(deletable_result)

      

$(document).ready(handle_comments)||$(document).on('page:load', handle_comments)||$(document).on('page:update', handle_comments)