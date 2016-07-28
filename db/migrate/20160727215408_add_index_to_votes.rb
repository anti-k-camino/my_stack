class AddIndexToVotes < ActiveRecord::Migration
  def change
    add_index :votes, [:user_id, :answer_id]
  end
end
