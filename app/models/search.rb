class Search < ActiveRecord::Base  
  SELECTION = %w(Question Answer Comment User All)

  def self.search_selection(query, selection)
    return [] unless SELECTION.include? selection
    if selection == 'All'
      ThinkingSphinx.search ThinkingSphinx::Query.escape(query)
    else
      selection.constantize.search ThinkingSphinx::Query.escape(query)
    end
  end
end
