require 'rails_helper'

RSpec.describe User, type: :model do 
  it { should validate_presence_of :name } 
  it { should validate_uniqueness_of(:name).case_insensitive } 
  it { should have_db_index :name }
  it { should have_many(:answers).dependent :destroy } 
  it { should have_many(:questions).dependent :destroy }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:votes).dependent :destroy }
  it { should have_many(:comments).dependent :destroy }
  it { should have_many(:authorizations).dependent :destroy }
  
  let(:user){ create :user } 
  let(:user1){ create :user }
  let(:question){ create :question, user: user }
  let(:answer){create :answer, user: user}
  

  it "user is the author of a question" do
   expect(user).to be_author_of question 
  end   
  it "user is not the author of a question" do
   expect(user1).to_not be_author_of question 
  end
  it "user is the author of a answer" do
   expect(user).to be_author_of answer 
  end   
  it "user is not the author of an answer" do
   expect(user1).to_not be_author_of answer 
  end

 describe '#create_authorization' do
  let!(:user){ create :user, confirmed_at: (Time.now-7)}  
  let(:twitter_auth){ OmniAuth::AuthHash.new(provider:'twitter', uid: '654321') }

  it "should create an authorization" do
    expect{ user.create_authorization!(twitter_auth) }.to change(user.authorizations, :count).by(1)
  end 

  it "should not create new user" do
    expect{ user.create_authorization!(twitter_auth) }.to_not change(User, :count)
  end 

  it "should create an authorization with twitter" do
    user.create_authorization!(twitter_auth)
    expect(user.authorizations.first.provider).to eq twitter_auth.provider
  end

  it "should create an authorization with propper uid" do
    user.create_authorization!(twitter_auth)
    expect(user.authorizations.first.uid).to eq twitter_auth.uid
  end

  it "should left user invalid (unconfirmed)" do
    user.create_authorization!(twitter_auth)
    #expect(user.confirmed_at).to eq nil
    expect(user.confirmed?).to be_falsy
  end

  it "should mail user to confirm" do
    expect{ user.create_authorization!(twitter_auth) }.to change(ActionMailer::Base.deliveries, :count).by(1)
  end

 end

 describe '.create_self_and_authorization!' do
  let(:twitter_auth){ OmniAuth::AuthHash.new(provider:'twitter', uid: '654321', info:{ name: 'Antonio Montana'}) }
  email = 'some@email.com'

  it 'should create new user' do    
    expect{ User.create_self_and_authorization!(twitter_auth, email) }.to change(User, :count).by(1)
  end

  it 'should create new user with name recieved from twitter' do
    User.create_self_and_authorization!(twitter_auth, email)
    expect(User.last.name).to eq twitter_auth['info']['name']
  end

  it 'should create new user with given email' do
    User.create_self_and_authorization!(twitter_auth, email)
    expect(User.last.email).to eq email
  end

  it 'should create authorization' do
    User.create_self_and_authorization!(twitter_auth, email)
    expect(User.last.authorizations.count).to eq 1
  end

  it 'should create twitter authorization' do
    User.create_self_and_authorization!(twitter_auth, email)
    expect(User.last.authorizations.first.provider).to eq twitter_auth['provider']
  end

  it 'should create authorization with propper uid' do
    User.create_self_and_authorization!(twitter_auth, email)
    expect(User.last.authorizations.first.uid).to eq twitter_auth['uid']
  end

  #it 'should left user invalid (unconfirmed)' do
    #User.create_self_and_authorization!(twitter_auth, email)
    #expect(User.last.confirmed?).to be_falsy
  #end

  #it 'should send confirmation mail to user' do
    #expect{ User.create_self_and_authorization!(twitter_auth, email); sleep 3 }.to change(ActionMailer::Base.deliveries, :count).by(1)
  #end 
 end


  describe '.find_for_oauth' do
    let!(:user){ create :user }
    let(:auth){ OmniAuth::AuthHash.new(provider:'facebook', uid: '123456') }
    let(:twitter_auth){ OmniAuth::AuthHash.new(provider:'twitter', uid: '654321') }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has no authorization' do
      context 'user already exists facebook' do
        let(:auth){ OmniAuth::AuthHash.new(provider:'facebook', uid: '123456', info: { email: user.email}) }

        it 'does not create new user' do
          expect {User.find_for_oauth(auth)}.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect {User.find_for_oauth(auth)}.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          user = User.find_for_oauth(auth)
          authorization = user.authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end
      context 'user does not exist' do
        let(:auth){ OmniAuth::AuthHash.new(provider:'facebook', uid: '123456', info: { email: 'new@user.com', name: 'UserName'}) }

        it 'creates new user' do
          expect { User.find_for_oauth(auth)}.to change(User, :count).by(1)
        end

        it 'does not send confirmation' do
          expect{ User.find_for_oauth(auth) }.to_not change(ActionMailer::Base.deliveries, :count)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

      end
    end

    context 'twitter' do
      context 'has authorization twitter' do
        
        it 'returns the user' do
          user.authorizations.create(provider: 'twitter', uid: '654321')
          expect(User.find_for_oauth(twitter_auth)).to eq user
        end
      end      
    end
  end

  describe '.send_daily_digest' do
    let(:users){ create_list(:user, 2) }

    it 'should send daily digest to all users' do
      users.each{ |user| expect(DailyMailer).to receive(:digest).with(user).and_call_original }
      User.send_daily_digest
    end
  end


end
