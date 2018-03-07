class PasswordsController < Devise::PasswordsController
  before_action :set_no_cache_headers, only: :new
end
