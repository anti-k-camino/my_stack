class AddCompositeINdexToAuthorizations < ActiveRecord::Migration
  def change
    add_index :authorizations, [:provider, :uid], unique: true
  end
end
