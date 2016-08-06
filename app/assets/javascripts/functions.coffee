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

  createVotes = (res, param) ->
    if res.vote.vote_field == -1      
      result = JST["create_vote"]
             rate: res.rating
             votee: { name: "/assets/down_red.png" }
             linkToo: (votee) ->                           
               @safe "<img src='#{votee.name}'/>"
             vote: { id: res.vote.id, name: "/assets/up.png" }
             linkTo: (vote) ->
               url  = "/votes/#{vote.id}"             
               @safe "<a data-confirm='Are you sure?' data-method='delete' class='#{param}' \
               data-remote=true href='#{url}'\
                 ><img alt='Delete' src='#{vote.name}'/></a>"             
    else
      result = JST["create_vote"]
             rate: res.rating
             votee: { id: res.vote.id, name: "/assets/down.png" }
             linkToo: (votee) ->
               url  = "/votes/#{votee.id}"             
               @safe "<a data-confirm='Are you sure?' alt='Delete' data-method='delete' class='#{param}'\
                data-remote=true href='#{url}'\
                 ><img  alt='Delete' src='#{votee.name}'/></a>"
             vote: { name: "/assets/up_red.png" }             
             linkTo: (vote) ->                           
               @safe "<img src='#{vote.name}'/>"
    result

  $('.create_vote').bind 'ajax:success', (e, data, status, xhr) ->    
    res = $.parseJSON(xhr.responseText)
    result = createVotes(res, 'delete_vote')                           
    $('.voting_dom').html(result)

  $('.create_answer_vote').bind 'ajax:success', (e, data, status, xhr) ->    
    res = $.parseJSON(xhr.responseText)
    result = createVotes(res, 'delete_answer_vote')       
    selector = '#vote_answer_dom_' + res.vote.votable_id                           
    $(selector).html(result)

  $('.delete_vote').bind 'ajax:success', (e, data, status, xhr) -> 
    res = $.parseJSON(xhr.responseText)
    result = JST["delete_vote"]
      rate: res.rating
      id: res.votable
      create_class: 'create_vote'
    $('.voting_dom').html(result)

  $('.delete_answer_vote').bind 'ajax:success', (e, data, status, xhr) -> 
    res = $.parseJSON(xhr.responseText)
    result = JST["delete_vote"]
      rate: res.rating
      id: ('/answers/' + res.votable)
      create_class: 'create_answer_vote'
    selector = '#vote_answer_dom_' + res.votable
    $(selector).html(result)    

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)

