module Admin

  class CategoriesController < BaseController
    before_action :set_category, only: %i[show update destroy move]

    def index
      authorize Category
      @categories = Category.published.roots.includes(:children)
    end

    def show
    end

    def new
      authorize Category
      @category = Category.new parent_id: params[:parent_id]
      @category.calculate_position
    end

    def create
      authorize Category
      @category = Category.new(category_params).tap(&:calculate_position)

      if @category.save
        redirect_to admin_categories_url, notice: t(:created, model: Category.model_name.human)
      else
        render :new
      end
    end

    def update
      if @category.update category_params
        redirect_to admin_categories_url, notice: t(:updated, model: Category.model_name.human)
      else
        render :edit
      end
    end

    def destroy
      msg =
        if @category.children.any?
          { alert: 'Kategorie hat noch Unterkategorien.' }
        else
          @category.update(archived: true) ? { notice: 'Navigation link deleted.' } : { alert: 'not possible' }
        end
      redirect_to admin_categories_url, msg
    end

    def move
      @category.move params[:dir]
      redirect_to admin_categories_url
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find params[:id]
      authorize @category
    end

    # Only allow a trusted parameter "white list" through.
    def category_params
      params.require(:category).permit(:name, :number, :category_id, :parent_id, :year, :archived)
    end
  end
end
