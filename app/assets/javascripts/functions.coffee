ready = ->  
  $(document).on 'click', '.toggle_edit_button', (e) ->
    e.preventDefault();
    object_id = $(this).data('answerId');        
    show = $('#show_answer' + object_id)
    edit = $('#edit_answer' + object_id) 
    $('#overlay').show();
    show.hide()
    edit.show()
  $(document).on 'click', '.edit_question_button', (e) ->
    e.preventDefault()   
    $('#overlay').show()
    show = $('.show_question')
    edit = $('.edit_question')
    show.hide()
    edit.show()
  $(document).on 'click', '.empty_vote', (e) ->
    e.preventDefault()    
    $('.voting_div').prepend('<p>You can vote only once</p>')    

  $('.create_vote').bind 'ajax:success', (e, data, status, xhr) ->    
    res = $.parseJSON(xhr.responseText)
    if res.vote.vote_field == -1      
      result = JST["create_vote"]
             rate: res.rating
             votee: { name: "/assets/down_red.png" }
             linkToo: (votee) ->
               url  = ""             
               @safe "<a href='' class='empty_vote'><img src='#{votee.name}'/></a>"
             vote: { id: res.vote.id, name: "/assets/up.png" }
             linkTo: (vote) ->
               url  = "/votes/#{vote.id}"             
               @safe "<a data-confirm='Are you sure?' data-method='delete' class='delete_vote' \
               data-remote=true href='#{url}'\
                 ><img src='#{vote.name}'/></a>"             
    else
      result = JST["create_vote"]
             rate: res.rating
             votee: { id: res.vote.id, name: "/assets/down.png" }
             linkToo: (votee) ->
               url  = "/votes/#{votee.id}"             
               @safe "<a data-confirm='Are you sure?' data-method='delete' class='delete_vote'\
                data-remote=true href='#{url}'\
                 ><img src='#{votee.name}'/></a>"
             vote: { name: "/assets/up_red.png" }             
             linkTo: (vote) ->
               url  = ""             
               @safe "<a href='' class='empty_vote'><img src='#{vote.name}'/></a>"                           
    $('.voting_dom').html(result)
  $('.delete_vote').bind 'ajax:success', (e, data, status, xhr) -> 
    res = $.parseJSON(xhr.responseText)
    result = JST["delete_vote"]
      rate: res.rating
      id: res.votable
    $('.voting_dom').html(result)
    alert('Thats all folks!!!')

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)

