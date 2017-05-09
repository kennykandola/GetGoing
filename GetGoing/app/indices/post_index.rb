ThinkingSphinx::Index.define :post, :with => :active_record do
  indexes title
  indexes body, :sortable => true
  indexes destination
end