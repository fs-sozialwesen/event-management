module Api
  class CategoriesController < BaseController

    def index
      @year = (params[:year] || Date.current.year).to_i
      @categories = Category.where(year: @year)
    end

  end
end
