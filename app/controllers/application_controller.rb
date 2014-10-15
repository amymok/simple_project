class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_project
    @current_project ||= Project.find_by_id(session[:project_id]) if session[:project_id]
  end
  helper_method :current_project
  
end
