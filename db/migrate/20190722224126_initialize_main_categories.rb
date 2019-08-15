class InitializeMainCategories < ActiveRecord::Migration[5.0]
  def change
    ["Creativity & Innovation",
     "Free Speech",
     "International",
     "Privacy",
     "Security",
     "Transparency"].each{ |t| Category.find_or_create_by!(title: t) }
  end
end
