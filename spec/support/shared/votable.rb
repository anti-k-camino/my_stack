RSpec.shared_examples_for 'User Votable' do
  
  let!(:user){ create :user } 
  let!(:sample_user){ create :user } 
  let!(:vote){ create :vote, user: user, votable: subject, vote_field: 1}   
  
  it 'user different from resource user is accapteble' do    
    expect(subject.user_voted?(sample_user)).to be_falsy
  end

  it 'user similar to resource user is accapteble' do
    expect(subject.user_voted?(user)).to be_truthy
  end
  
end