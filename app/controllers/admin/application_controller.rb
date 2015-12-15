require 'quotes'
class Admin::ApplicationController < ApplicationController
  layout 'admin'
  before_filter :must_be_admin

  def manifest
    self.class.manifest || 'admin'
  end

  protected
  def must_be_admin
    unless user_signed_in? && current_user.admin?
      raise ActiveRecord::RecordNotFound
    end
  end

  def images
  end
end
