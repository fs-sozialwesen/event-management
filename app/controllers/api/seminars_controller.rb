module Api
  class SeminarsController < BaseController

    def index
      @filter = filter
      @category = Category.find_by id: params[:category_id]
      @seminars = @category ? @category.seminars : Seminar.where(year: @filter[:year])

      @seminars = @seminars.published.order(@filter[:order]).includes(:teachers, :events, :categories).
        page(@filter[:page]).per(@filter[:per_page])
      @seminars = @seminars.where('date >= ?', @filter[:date_start]) if @filter[:date_start]
      @seminars = @seminars.where('date <= ?', @filter[:date_end])   if @filter[:date_end]
      @seminars = @seminars.external_search @filter[:search_term]    if @filter[:search_term]

      expires_in cache_time, public: true
      stale? @seminars
    end

    def show
      @seminar = Seminar.published.find_by(id: params[:id])&.decorate

      expires_in cache_time, public: true
      stale? @seminar
      render json: {}, status: :not_found unless @seminar
    end

    protected

    def cache_time
      10.minutes
    end

    private

    def filter
      filter = {}
      filter[:year] = (params[:year] || Date.current.year).to_i
      filter[:page] = params[:page]
      filter[:per_page] = params[:per_page]
      filter[:order] = params[:sort_by].in?(%w(date title)) ? params[:sort_by] : :date
      filter[:order] = { filter[:order] => params[:sorting] } if params[:sorting].in?(%w(asc desc))
      filter[:date_start] = get_date :date_start
      filter[:date_end]   = get_date :date_end
      filter[:search_term] = params[:search_term]
      filter
    end

    def get_date(start_or_end)
      return nil unless params[start_or_end]
      Date.parse params[start_or_end]
    rescue ArgumentError
      nil
    end

  end
end
