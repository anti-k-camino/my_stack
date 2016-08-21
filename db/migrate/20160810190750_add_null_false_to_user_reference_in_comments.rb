class AddNullFalseToUserReferenceInComments < ActiveRecord::Migration
  def change
    remove_index :comments, :user_id
    remove_reference :comments, :user
    add_reference :comments, :user, null: false, index: true
  end
end
