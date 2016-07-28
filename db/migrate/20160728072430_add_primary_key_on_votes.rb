class AddPrimaryKeyOnVotes < ActiveRecord::Migration
  def change
    set_primary_key :votes, [:user_id, :answer_id]
  end
end
