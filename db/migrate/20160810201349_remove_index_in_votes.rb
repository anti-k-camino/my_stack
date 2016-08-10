class RemoveIndexInVotes < ActiveRecord::Migration
  def change
    remove_index :votes, ["user_id", "votable_id", "votable_type"]
  end
end
