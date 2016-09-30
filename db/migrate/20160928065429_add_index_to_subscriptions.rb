class AddIndexToSubscriptions < ActiveRecord::Migration
  def change
    add_index :subscriptions, [:user_id, :question_id]
  end
end
