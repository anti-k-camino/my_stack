$ ->
  PrivatePub.subscribe '/questions', (data, channel) ->
    method = data.resp['method']       
    if method is 'create'
      question = $.parseJSON(data.resp['question'])       
      $('.questions_list').append("<li id='q_#{question.id}'><a href='/questions/#{question.id}'>#{question.title}</a></li>")   
    else if method is 'destroy'
      question = $.parseJSON(data.resp['question'])
      id = "#q_" + question.id      
      $(id).remove()