class AddCompositeIndexOnUserCommentableComments < ActiveRecord::Migration
  def change
    add_index :comments, [:user_id, :commentable_type, :commentable_id], name: "comment_index"
  end
end
