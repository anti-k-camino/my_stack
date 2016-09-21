shared_examples_for "User Ownerable" do
  it { should belong_to :user } 
  it { should validate_presence_of :user_id } 
  it { should have_db_index :user_id }
end