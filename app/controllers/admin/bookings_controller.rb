module Admin

  class BookingsController < BaseController

    def show
      @booking = Booking.find(params[:id] || params[:booking_id])
      @seminar = @booking.seminar.decorate
      authorize @booking
    end

    def new
      authorize Booking
      @seminar = Seminar.find(params[:seminar_id]).decorate
      @booking = @seminar.bookings.build
      prepare_attendees
      session[:attendee_back_url] = admin_seminar_url(@seminar, anchor: 'attendees')
    end

    def create
      authorize Booking
      @booking = Booking.new booking_params
      @booking.external = false
      copy_fields_to_attendees

      if @booking.save
        redirect_to session[:attendee_back_url], notice: t(:created, model: Booking.model_name.human)
      else
        @seminar = Seminar.find(@booking.seminar_id).decorate
        prepare_attendees
        render :new
      end
    end

    private

    def prepare_attendees
      10.times { @booking.attendees.build seminar_id: @booking.seminar_id }
    end

    def copy_fields_to_attendees
      attributes = %w[seminar_id company_id contact company_address invoice_address
                      member member_institution school year graduate comments reduction]
      attributes = @booking.attributes.slice(*attributes)
      @booking.attendees.each { |attendee| attendee.assign_attributes attributes }
    end

    # Only allow a trusted parameter "white list" through.
    def booking_params
      attrs = [
        :seminar_id, :member, :member_institution, :graduate, :school, :year, :terms_of_service, :reduction,
        :contact_person, :contact_email, :contact_phone, :contact_mobile, :contact_fax, :comments,
        :company_title, :company_street, :company_zip, :company_city, :company_id,
        :invoice_title, :invoice_street, :invoice_zip, :invoice_city,
        attendees_attributes: %i[id first_name last_name profession _destroy seminar_id] + [
          address: %i[street zip city], contact: %i[email phone mobile]
        ]
      ]
      params.require(:booking).permit(attrs)
    end
  end
end
