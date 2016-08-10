class RemoveReferenceFromComments < ActiveRecord::Migration
  def change
    rename_column :comments, :commentable_id_id, :commentable_id
  end
end
