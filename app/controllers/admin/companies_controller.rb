module Admin
  class CompaniesController < BaseController
    before_action :set_company, only: %i[show update destroy]

    def index
      authorize Company
      @companies = Company.order(:name)

      respond_to do |format|
        format.html { @companies = @companies.page(params[:page]).all }
        format.xlsx { @companies = @companies.all }
      end
    end

    def show
      @year = (params[:year] || current_year).to_i
      @years = Catalog.pluck(:year).sort
    end

    def new
      authorize Company
      @company = Company.new
    end

    def create
      authorize Company
      @company = Company.new company_params

      if @company.save
        redirect_to admin_companies_url, notice: t(:created, model: Company.model_name.human)
      else
        render :new
      end
    end

    def update
      if @company.update company_params
        redirect_to admin_companies_url, notice: t(:updated, model: Company.model_name.human)
      else
        render :show
      end
    end

    def destroy
      @company.destroy
      if @company.destroyed?
        redirect_to admin_companies_url, notice: t(:destroyed, model: Company.model_name.human)
      else
        msg = 'Es existieren Buchungen / Teilnehmer.'
        msg = t(:not_destroyed, model: Company.model_name.human, message: msg)
        redirect_to admin_company_url(@company), alert: msg
      end
    end

    private

    def set_company
      @company = Company.find params[:id]
      authorize @company
    end

    def company_params
      params.require(:company).permit(:name, :name2, :street, :zip, :city, :city_part, :phone, :mobile, :fax, :email)
    end
  end
end
