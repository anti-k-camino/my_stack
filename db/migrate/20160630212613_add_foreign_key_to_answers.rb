class AddForeignKeyToAnswers < ActiveRecord::Migration
  def change
     add_foreign_key :answers, :questions, on_delete: :cascade
  end
end
