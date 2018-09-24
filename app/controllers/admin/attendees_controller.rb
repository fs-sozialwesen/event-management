module Admin
  class AttendeesController < BaseController

    before_action :set_attendee, only: %i(show update destroy cancel)

    def index
      authorize Attendee
      @month = (params[:month] || Date.current.month).to_i
      date_range = current_catalog.date_range @month
      @attendees =
        Attendee.
          booked.
          where(created_at: date_range).
          includes(:seminar, :company, :booking).
          order(created_at: :desc).page(params[:page]).all
      session[:attendee_back_url] = admin_attendees_url(month: @month)
    end

    def company
      authorize Attendee
      @date_range = current_catalog.date_range
      @companies = Company.order(:name).where(id: Attendee.where(created_at: @date_range).select(:company_id))
      @company = Company.find_by(id: params[:company_id]) if params[:company_id]
      return unless @company
      @attendees = @company.attendees.where(created_at: @date_range).order(created_at: :desc)
    end

    def show
    end

    def cancel
    end

    def update
      if @attendee.update attendee_params
        redirect_to session[:attendee_back_url], notice: t(:updated, model: Attendee.model_name.human)
      else
        render :show
      end
    end

    def destroy
      cancellation_reason = params.require(:attendee).permit(:cancellation_reason)[:cancellation_reason]
      if cancellation_reason.present?
        @attendee.cancel! reason: cancellation_reason, user: current_user
        BookingMailer.attendee_canceled_email(@attendee).deliver_later
        redirect_to (session[:back_url] || admin_seminar_url(@attendee.seminar)), notice: t('admin.attendees.cancel.notice')
      else
        @attendee.errors.add :cancellation_reason, :must_be_filled
        render :cancel
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_attendee
      @attendee = Attendee.find(params[:id] || params[:attendee_id])
      @seminar  = @attendee.seminar.decorate
      authorize @attendee
    end

    # Only allow a trusted parameter "white list" through.
    def attendee_params
      attrs = %i(
        first_name last_name member member_institution graduate school year terms_of_service reduction
        contact_person contact_email contact_phone contact_mobile contact_fax comments
        company_title company_street company_zip company_city company_id
        invoice_title invoice_street invoice_zip invoice_city
        tandem_name tandem_company tandem_address
      )
      params.require(:attendee).permit(attrs)
    end

  end
end
