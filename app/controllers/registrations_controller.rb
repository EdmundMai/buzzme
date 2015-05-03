class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token
  respond_to :json
  p
  before_filter :configure_permitted_parameters

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:industry, :company_name)
  end
end
