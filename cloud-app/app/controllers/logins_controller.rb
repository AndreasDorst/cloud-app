class LoginsController < ApplicationController
include Authentification
  # skip_before_action :require_login, only: [:show, :create]

  def show
    @balance = session[:balance]
  end

  def create
    notice = LoginService.new(params, session).call
    redirect_to :login, notice: notice
  end

  def destroy
    session.delete(:login)
    session.delete(:balance)
    redirect_to :login, notice: 'Вы вышли'
  end

  # private

  # def require_login
  #   unless session[:login]
  #   redirect_to login_path, alert: "Требуется логин"
  #   end
  # end
end