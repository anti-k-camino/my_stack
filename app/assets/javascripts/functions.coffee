ready = ->  
  $(document).on 'click', '.toggle_edit_button', (e) ->
    e.preventDefault();
    object_id = $(this).data('answerId');        
    show = $('#show_answer' + object_id)
    edit = $('#edit_answer' + object_id) 
    $('#overlay').show();
    show.hide();
    edit.show();
  $(document).on 'click', '.edit_question_button', (e) ->
    e.preventDefault();    
    $('#overlay').show();
    show = $('.show_question')
    edit = $('.edit_question')
    show.hide();
    edit.show();

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
