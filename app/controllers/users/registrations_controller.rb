class Users::RegistrationsController < Devise::RegistrationsController
  before_action :check_guest, only: [:update, :destroy]
end
