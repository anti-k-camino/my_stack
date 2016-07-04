class AddForeignKeyOnUsersToQuestions < ActiveRecord::Migration
  def change
    add_foreign_key :questions, :users, on_delete: :cascade
  end
end
