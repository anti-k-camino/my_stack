class AddPolymorphicCommentableToComments < ActiveRecord::Migration
  def change
    add_reference :comments, :commentable_id
    add_column :comments, :commentable_type, :string
  end
end
