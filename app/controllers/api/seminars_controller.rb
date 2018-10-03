module Api
  class SeminarsController < BaseController

    def index
      @year = (params[:year] || Date.current.year).to_i
      @category = Category.find_by id: params[:category_id]
      @seminars = @category ? @category.seminars : Seminar.where(year: @year)
      @seminars = @seminars.
        published.
        order(:date).
        includes(:teachers, :events, :categories).
        page(params[:page]).
        per(params[:per_page])
    end

    def show
      @seminar = Seminar.published.find_by(id: params[:id])&.decorate
      render json: {}, status: :not_found unless @seminar
    end

  end
end
