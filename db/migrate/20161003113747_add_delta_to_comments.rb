class AddDeltaToComments < ActiveRecord::Migration
  def change
    add_column :comments, :delta, :boolean, default: true
  end
end
