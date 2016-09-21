shared_examples_for "API Authenticable Post" do
  context 'non authorized user' do
    it 'returns 401 status if there is no access token' do
      do_post_request
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access token is invalid' do
      do_post_request(access_token: "123123")
      expect(response.status).to eq 401
    end 
  end 
end