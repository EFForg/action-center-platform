class Admin::ApplicationController < ApplicationController
  layout "admin"
  before_filter :must_be_admin

  protected

  def self.allow_collaborators_to(*actions)
    skip_before_filter :must_be_admin, only: actions
    before_filter :must_be_admin_or_collaborator, only: actions
  end

  def must_be_admin
    unless user_signed_in? && current_user.admin?
      raise ActiveRecord::RecordNotFound
    end
  end

  def must_be_admin_or_collaborator
    unless user_signed_in? && (current_user.admin? || current_user.collaborator?)
      raise ActiveRecord::RecordNotFound
    end
  end

  def images
  end
end
