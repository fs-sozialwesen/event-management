class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :page_not_found
  rescue_from ActionController::RoutingError, with: :page_not_found

  before_action :set_paper_trail_whodunnit
  before_action :set_new_nav

  helper_method :current_catalog
  helper_method :current_year

  layout :layout_by_resource

  private

  def layout_by_resource
    # needed for password change view
    devise_controller? && current_user ? 'admin' : 'application'
  end

  # remove after hompage launch
  def set_new_nav
    session[:new_nav] = true if params[:nav_neu] == '1'
    session.delete(:new_nav) if params[:nav_neu] == '0'
  end

  def current_year
    @current_year ||= (session[:current_year] || Date.current.year)
  end

  def current_year=(year)
    session[:current_year] = year
  end

  def current_catalog
    @current_catalog ||= Catalog.find_by(year: current_year)
  end

  def current_catalog=(catalog)
    session[:current_year] = catalog.year
    @current_catalog = catalog
  end

  def user_not_authorized
    flash[:alert] = t("not_authorized.#{request.get? ? :page : :action}")
    redirect_to(request.referrer || root_path)
  end

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end

  def after_sign_in_path_for(_resource)
    admin_root_path
  end

  def page_not_found
    render 'page_not_found', status: :not_found
  end
end
