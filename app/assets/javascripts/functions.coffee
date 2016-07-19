ready = ->  
  $('.toggle_edit_button').click (e) -> 
    e.preventDefault();
    object_id = $(this).data('answerId');        
    show = $('#show_answer' + object_id)
    edit = $('#edit_answer' + object_id) 
    show.hide();
    edit.show();
$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
