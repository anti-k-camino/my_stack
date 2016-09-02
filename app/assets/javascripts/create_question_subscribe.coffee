$ ->
  PrivatePub.subscribe '/questions', (data, channel) ->
    question = $.parseJSON(data['question'])    
    $('.questions_list').append("<li><a href='/questions/#{question.id}'>#{question.title}</a></li>");