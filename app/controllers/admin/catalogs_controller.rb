module Admin

  class CatalogsController < BaseController
    before_action :set_catalog, only: %i[show update destroy make_current]

    def index
      authorize Catalog
      @catalogs = Catalog.all
    end

    def show
      respond_to do |format|
        format.html
        format.xlsx
      end
    end

    def new
      authorize Catalog
      @catalog = Catalog.new
    end

    def create
      authorize Catalog
      @catalog = Catalog.new catalog_params

      if @catalog.save
        redirect_to admin_catalogs_path, notice: t(:created, model: Catalog.model_name.human)
      else
        render :new
      end
    end

    def update
      if @catalog.update catalog_params
        redirect_to admin_catalogs_path, notice: t(:updated, model: Catalog.model_name.human)
      else
        render :edit
      end
    end

    def destroy
      @catalog.destroy
      redirect_to admin_catalogs_url, notice: t(:destroyed, model: Catalog.model_name.human)
    end

    def make_current
      self.current_year = @catalog.year
      redirect_to admin_root_url
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_catalog
      @catalog = Catalog.find params[:id]
      authorize @catalog
    end

    # Only allow a trusted parameter "white list" through.
    def catalog_params
      params.require(:catalog).permit(:title, :year, :published, :print_version)
    end
  end
end
