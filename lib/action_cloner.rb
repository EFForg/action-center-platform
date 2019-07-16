class ActionCloner
  def self.clone(*args)
    new(*args).clone
  end

  def initialize(action_page)
    @attrs = action_page.attributes.symbolize_keys
  end

  def clone
    clean_attributes
    ActionPage.new(attrs)
  end

  private

  attr_accessor :attrs


  def clean_attributes
    unpublish
    unarchive
    remove_attrs
  end

  def unpublish
    attrs[:published] = false
  end

  def unarchive
    attrs[:archived] = false
  end

  def remove_attrs
    attrs.delete :created_at
    attrs.delete :updated_at
    attrs.delete :slug
  end
end
