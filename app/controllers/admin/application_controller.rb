class Admin::ApplicationController < ApplicationController
  layout "admin"
  before_action :must_be_admin

  def manifest
    self.class.manifest || "admin"
  end

  # FLAG_AS_UNUSED
  def self.allow_collaborators_to(*actions)
    skip_before_action :must_be_admin, only: actions
    before_action :must_be_admin_or_collaborator, only: actions
  end

  def must_be_admin
    raise ActiveRecord::RecordNotFound unless user_signed_in? && current_user.admin?
  end

  def must_be_admin_or_collaborator
    raise ActiveRecord::RecordNotFound unless user_signed_in? && (current_user.admin? || current_user.collaborator?)
  end

  def images; end
end
