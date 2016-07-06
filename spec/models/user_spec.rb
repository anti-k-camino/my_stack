require 'rails_helper'

RSpec.describe User, type: :model do 
  it { should validate_presence_of :name } 
  it { should validate_uniqueness_of(:name).case_insensitive } 
  it { should have_db_index :name }
  it { should have_many(:answers).dependent(:destroy) } 
  it { should have_many(:questions).dependent(:destroy) }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
end
