module Api
  class CategoriesController < BaseController

    def index
      @year = (params[:year] || Date.current.year).to_i
      @categories = Category.where(year: @year).roots

      expires_in cache_time, public: true
      stale? @categories
    end

    def show
      @categories = Category.find_by(id: params[:id])&.children

      expires_in cache_time, public: true
      stale? @categories
      render 'index'
    end

    def tree
      @year = (params[:year] || Date.current.year).to_i
      @categories = Category.where(year: @year).roots

      expires_in cache_time, public: true
      stale? @categories
    end

  end
end
