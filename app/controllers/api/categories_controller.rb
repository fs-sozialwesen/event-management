module Api
  class CategoriesController < BaseController

    def index
      @year = (params[:year] || Date.current.year).to_i
      parent_id = params[:parent_id]
      @filter = parent_id.present? ? { parent_id: parent_id } : { year: @year }
      @categories = Category.where(@filter)
    end

    def tree
      @year = (params[:year] || Date.current.year).to_i
      @categories = Category.where(year: @year).roots
    end

  end
end
