ThinkingSphinx::Index.define :answer, with: :active_record, delta: true do
  # fields
  indexes body
  indexes user.email, as: :author, sortable: true

  # attributes
  has user_id, created_at, updated_at
end