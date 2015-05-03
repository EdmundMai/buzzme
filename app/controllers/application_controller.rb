class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    queue_path
  end

  def set_client
    @client ||= if ios_app?
      Client.find(params[:client_id])
    else
      current_client
    end
  end

  def ios_app?
    params[:os].present?
  end
end
