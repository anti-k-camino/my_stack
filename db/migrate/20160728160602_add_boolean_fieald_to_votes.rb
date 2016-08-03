class AddBooleanFiealdToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :vote_field, :boolean, index: true 
  end
end
