shared_examples_for "Ownerable" do
  it { should validate_presence_of :body }  
  it { should have_many(:attachments).dependent :destroy }
  it { should accept_nested_attributes_for :attachments }
  it { should have_many(:comments).dependent :destroy }
end