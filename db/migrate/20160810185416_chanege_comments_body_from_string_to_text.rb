class ChanegeCommentsBodyFromStringToText < ActiveRecord::Migration
  def change
    remove_column :comments, :body 
    add_column :comments, :body, :text
  end
end
