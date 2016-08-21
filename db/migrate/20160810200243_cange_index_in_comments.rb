class CangeIndexInComments < ActiveRecord::Migration
  def change
    remove_index :comments, :user_id
    add_index :comments, [:user_id, :commentable_id, :commentable_type], name: 'comment_index'
  end
end
