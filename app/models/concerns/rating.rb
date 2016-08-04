module Rating
  extend ActiveSupport::Concern
  include Votings
  def rating
    self.votes.sum(:vote_field)  
  end
end