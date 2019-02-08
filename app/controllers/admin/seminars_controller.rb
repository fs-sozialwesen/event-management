module Admin
  class SeminarsController < BaseController

    before_action :set_seminar, only:
      %i(show edit update destroy attendees pras versions toggle_category publish unpublish finish_editing finish_layout)

    def index
      authorize Seminar
      respond_to do |format|
        format.html { redirect_to action: :category }
        format.xlsx { @seminars = current_catalog.seminars }
      end
    end

    def category
      authorize Seminar
      categories              = current_catalog.categories
      @category               = categories.find_by(id: params[:id])
      seminars                = current_catalog.seminars
      @uncategorized_seminars = seminars.where.not(id: seminars.joins(:categories).select(:id))
      @seminars               = @category ? @category.all_seminars : @uncategorized_seminars
      respond_to do |format|
        format.html { @seminars = @seminars.page(params[:page]) }
        format.xlsx { render 'with_all_categories' unless @category }
      end
    end

    def date
      authorize Seminar
      # @month    = params[:month].to_i
      # @seminars = current_catalog.seminars.by_month(@month)


      @month         = (params[:month] || Date.current.month).to_i
      first_of_month = Date.new current_catalog.year, @month
      @days_of_month = first_of_month..first_of_month.end_of_month
      @events        = Event.order(:date).joins(:seminar).includes(:seminar).where(date: @days_of_month)
      @seminars      = Seminar.where(id: @events.select(:seminar_id))
      respond_to do |format|
        format.html { @seminars = @seminars.page(params[:page]) }
        format.xlsx
      end
    end

    def calendar
      authorize Seminar
      @month         = (params[:month] || Date.current.month).to_i
      first_of_month = Date.new current_catalog.year, @month
      @days_of_month = first_of_month..first_of_month.end_of_month
      @events        = Event.order(:date).joins(:seminar).includes(:seminar).where(date: @days_of_month)
      @seminars      = Seminar.where(id: @events.select(:seminar_id)).page(params[:page])
      respond_to do |format|
        format.html
        format.xlsx { render :date }
      end
    end

    def canceled
      authorize Seminar
      @seminars = current_catalog.seminars.canceled.page(params[:page])
    end

    def filter
      authorize Seminar
      return unless request.xhr? || request.format == :xlsx
      @filter   = params.require(:seminar_filter).permit(:number1, :number2, :number3)
      @seminars = current_catalog.seminars.by_number @filter
      render layout: false
    end

    def editing_status
      authorize Seminar
      @scopes   = %i(all editing_not_finished layout_open editing_changed completed)
      @scope    = params[:scope].to_s.to_sym
      @scope    = @scopes.first unless @scope.in? @scopes
      @seminars = current_catalog.seminars.page(params[:page]).send @scope
    end

    def show
      session[:attendee_back_url] = admin_seminar_path(@seminar, anchor: 'attendees')
      respond_to do |format|
        format.html
        format.pdf { render pdf: "#{Seminar.model_name.human}_#{@seminar.number}", show_as_html: params.key?('debug') }
      end
    end

    def new
      authorize Seminar
      @seminar = Seminar.new new_seminar_params
      @seminar.build_legal_statistic.fill_defaults
      10.times { @seminar.events.build }
    end

    def edit
      10.times { @seminar.events.build }
    end

    def create
      authorize Seminar
      @seminar = Seminar.new seminar_params
      copy_data_for @seminar
      @seminar.legal_statistic.fill_dates

      if @seminar.save
        redirect_to after_save_url, notice: t(:created, model: Seminar.model_name.human)
      else
        10.times { @seminar.events.build }
        render :new
      end
    end

    def update
      @seminar.editing_finished_at = DateTime.current if @seminar.editing_finished?

      if @seminar.update seminar_params
        redirect_to after_save_url, notice: t(:updated, model: Seminar.model_name.human)
      else
        10.times { @seminar.events.build }
        render :edit
      end
    end

    def destroy
      @seminar.destroy
      redirect_to admin_seminars_url, notice: t(:destroyed, model: Seminar.model_name.human)
    end

    def attendees
      @attendees = @seminar.attendees.order(:created_at)
      render 'attendees_emails' if params[:emails].present?
    end

    def pras
    end

    def versions
    end

    def toggle_category
      if (category = Category.find params[:category_id])
        if category.in? @seminar.categories
          @seminar.categories.delete category
        else
          @seminar.categories << category
        end
      end
    end

    def search
      authorize Seminar
    end

    def publish
      @seminar.update published: true
      redirect_to after_save_url, notice: 'Seminar freigegeben.'
    end

    def unpublish
      @seminar.update published: false
      redirect_to after_save_url, notice: 'Seminar deaktiviert.'
    end

    def finish_editing
      new_finished_date = @seminar.editing_finished? ? nil : DateTime.current
      @seminar.update editing_finished_at: new_finished_date
      redirect_to after_save_url, notice: 'Erfolgreich geändert'
    end

    def finish_layout
      new_finished_date = @seminar.layout_finished? ? nil : DateTime.current
      @seminar.update layout_finished_at: new_finished_date
      redirect_to after_save_url, notice: 'Erfolgreich geändert'
    end

    private

    def after_save_url
      admin_seminar_path(@seminar, anchor: 'general')
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_seminar
      @seminar = Seminar.unscoped.find(params[:id]).decorate
      authorize @seminar
    end

    # Only allow a trusted parameter "white list" through.
    def seminar_params
      params.require(:seminar).permit policy(Seminar).permitted_attributes
    end

    def new_seminar_params
      attrs = {}
      if params[:copy_from].present? && (sem = Seminar.find_by(id: params[:copy_from]))
        attrs = sem.attributes.except('id', 'published').merge(
          teachers:     sem.teachers,
          copy_from_id: sem.id
        )
      end
      attrs[:year] = current_year
      attrs
    end

    def copy_data_for(seminar)
      return unless seminar.original.present? && seminar.year == seminar.original.year
      seminar.categories = seminar.original.categories
    end
  end
end
