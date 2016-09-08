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

  describe '.find_by_email' do
    let!(:users){ create_list :user, 3 }

    it 'should return correct user if matches' do
      expect(User.find_by_email(users[1].email)).to eq users[1]
    end

    it 'should return nil if no matches founded' do
      expect(User.find_by_email('exam@email.com')).to eq nil
    end
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
    context 'has authorization twitter' do
      it 'returns the user' do
        user.authorizations.create(provider: 'twitter', uid: '654321')
        expect(User.find_for_oauth(twitter_auth)).to eq user
      end
    end

    context 'user allready exists twitter' do
      it 'does not create new user' do
        expect {User.find_for_oauth(twitter_auth)}.to_not change(User, :count)
      end

      it 'creates authorization for user' do
        expect {User.find_for_oauth(twitter_auth)}.to change(user.authorizations, :count).by(1)
      end

      it 'creates authorization with provider and uid' do
        user = User.find_for_oauth(twitter_auth)
        authorization = user.authorizations.first
        expect(authorization.provider).to eq twitter_auth.provider
        expect(authorization.uid).to eq twitter_auth.uid
      end

      it 'returns user' do
        expect(User.find_for_oauth(twitter_auth)).to eq user
      end

    end
  end
 

end
