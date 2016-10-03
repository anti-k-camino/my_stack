class AddDewltaToUsers < ActiveRecord::Migration
  def change
    add_column :users, :delta, :boolean, default: true
  end
end
