module Authentification
  extend ActiveSupport::Concern

  private

  def require_login
    return if session[:login]
    
    respond_to do |format|
      format.html { redirect_to login_path, alert: "Требуется логин" }
      format.json { render json: { result: false, error: "Unauthorized" }, status: :unauthorized } 
    end
  end
end