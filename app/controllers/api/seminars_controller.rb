module Api
  class SeminarsController < BaseController

    def index
      @filter = filter
      @category = Category.find_by id: params[:category_id]
      @seminars = @category ? @category.all_seminars : Seminar

      @seminars = @seminars.includes(:events, :categories).published.order(@filter[:order]).page(@filter[:page]).per(@filter[:per_page])
      @seminars = @seminars.where(year: @filter[:year])                       if @filter[:year]
      @seminars = @seminars.where('seminars.date >= ?', @filter[:date_start]) if @filter[:date_start]
      @seminars = @seminars.where('seminars.date <= ?', @filter[:date_end])   if @filter[:date_end]
      @seminars = @seminars.bookable                                          if @filter[:only_bookable]
      @seminars = @seminars.recommended                                       if @filter[:recommended]
      @seminars = @seminars.where(location_id: @filter[:location_ids])        if @filter[:location_ids].any?
      # @seminars = @seminars.external_search @filter[:search_term]             if @filter[:search_term]
      @seminars = @seminars.ext_search(@filter[:search_term]).distinct        if @filter[:search_term]

      expires_in cache_time, public: true
      # stale? @seminars
    end

    def show
      @seminar = Seminar.published.find_by(id: params[:id])&.decorate

      expires_in cache_time, public: true
      # stale? @seminar
      render json: {}, status: :not_found unless @seminar
    end

    def docs
    end

    protected

    def cache_time
      10.minutes
    end

    private

    def filter
      filter = {}
      filter[:year]          = params[:year]
      filter[:page]          = params[:page]
      filter[:per_page]      = params[:per_page]
      filter[:order]         = sort_by
      filter[:date_start]    = get_date :date_start
      filter[:date_end]      = get_date :date_end
      filter[:only_bookable] = !params.key?(:with_outdated)
      filter[:recommended]   = params.key?(:recommended)
      filter[:location_ids]  = params[:location_ids].to_s.split(',')
      filter[:search_term]   = params[:search_term]
      filter
    end

    def sort_by
      order = 'date'
      order = "regexp_replace(title, '\\W+', '', 'g')" if params[:sort_by] == 'title'
      order = "#{order} desc"                          if params[:sorting] == 'desc'
      order
    end

    def get_date(start_or_end)
      return nil unless params[start_or_end]
      Date.parse params[start_or_end]
    rescue ArgumentError
      nil
    end

  end
end
