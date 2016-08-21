class AddUniqueCompositIndexVotes < ActiveRecord::Migration
  def change
    add_index :votes, ["user_id", "votable_id", "votable_type"], unique: true, name: 'vote_index'
  end
end
