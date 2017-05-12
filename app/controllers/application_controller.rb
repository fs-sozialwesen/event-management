class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound , with: :page_not_found
  rescue_from ActionController::RoutingError, with: :page_not_found

  before_action :set_paper_trail_whodunnit

  helper_method :current_catalog
  helper_method :set_current_catalog

  private

  def current_catalog
    @current_catalog ||= Catalog.find_by year: (session[:current_year] || Date.current.year)
  end

  def current_catalog=(catalog)
    session[:current_year] = catalog.year
    @current_catalog = catalog
  end

  def user_not_authorized
    flash[:alert] = 'Du bist nicht berechtigt, diese Seite zu sehen.'
    redirect_to (request.referrer || root_path)
  end

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    seminare_visitor_path
  end

  def page_not_found
    render 'page_not_found', status: :not_found
  end
end
