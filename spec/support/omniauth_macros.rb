module OmniauthMacros
  def mock_auth_facebook_hash
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(provider: 'facebook',
                                                                  uid: '123456',
                                                                  info: { email: 'user@email.com', name: 'SomeName' })
  end

  def mock_auth_twitter_hash
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(provider: 'twitter',
                                                                  uid: '123456',
                                                                  info: { name: 'SomeName' })
  end

  def invalid_credentials
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
  end
end