class ApplicationController < ActionController::Base
  include Authentification
  allow_browser versions: :modern
end
