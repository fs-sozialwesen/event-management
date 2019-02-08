module Api
  class CategoriesController < BaseController

    def index
      @year = (params[:year] || Date.current.year).to_i
      @categories = Category.where(year: @year).roots

      expires_in cache_time, public: true
      stale? @categories
    end

    def show
      @category = Category.find_by(id: params[:id])

      expires_in cache_time, public: true
      stale? @category
    end

    def tree
      @year = (params[:year] || Date.current.year).to_i
      @categories = Category.where(year: @year).roots

      expires_in cache_time, public: true
      stale? @categories
    end

  end
end
