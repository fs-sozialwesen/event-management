class SeminareController < ApplicationController

  def index
    @year            = params[:year].to_i
    @published_years = Catalog.published.pluck(:year).select { |year| year >= Date.current.year }
    return redirect_to(seminare_visitor_path(year: @published_years.first)) unless @year.in?(@published_years)
    @catalog  = Catalog.find_by(year: @year)
    @category = @catalog.categories.find_by(id: params[:category_id]) #|| @catalog.categories.roots.first
    @seminars = (@category ? @category.all_seminars : Seminar.where(year: @year)).published
    # @seminars = @seminars.page(params[:page])
  end

  def home
    @year            = params[:year].to_i
    @published_years = Catalog.published.pluck(:year).select { |year| year >= Date.current.year }
    return redirect_to(seminare_visitor_path(year: @published_years.first)) unless @year.in?(@published_years)
    @catalog = Catalog.find_by(year: @year)
  end

  def show
    seminar_scope = Seminar
    seminar_scope = seminar_scope.published unless current_user&.admin?
    @seminar      = seminar_scope.find(params[:id]).decorate
  end

  def search
    @query = params[:q]
    @published_years = Catalog.published.pluck(:year).select { |year| year >= Date.current.year }
    # @seminars = Seminar.published.where(year: @published_years).external_search @query
    @seminars = Seminar.published.where(year: @published_years).ext_search @query
  end
end
