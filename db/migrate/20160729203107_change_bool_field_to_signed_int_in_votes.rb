class ChangeBoolFieldToSignedIntInVotes < ActiveRecord::Migration
  def change
    remove_columns :votes, :vote_field    
    add_column :votes, :vote_field, :integer    
  end
end
