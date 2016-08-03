FactoryGirl.define do 

 
  factory :vote_questions, class:'Vote' do
    votable_id 1
    votable_type "Question"
    user_id 1
    vote_field true
  end

  factory :vote_answers, class:'Vote' do
    votable_id 
    votable_type "Answer"
    user_id 
    vote_field true
  end

end
