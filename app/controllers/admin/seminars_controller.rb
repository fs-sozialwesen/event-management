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

      @month = (params[:month] || Date.current.month).to_i
      @seminars = Seminar.by_year_and_month current_year, @month

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
      @seminars      = Seminar.by_year_and_month(current_year, @month).page(params[:page])
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

    def recommended
      authorize Seminar
      @seminars = current_catalog.seminars.recommended.page(params[:page])
    end

    def show
      session[:attendee_back_url] = admin_seminar_path(@seminar, anchor: 'attendees')
      respond_to do |format|
        format.html
        format.pdf { render pdf_options_for(@seminar) }
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

    def pdf_options_for(seminar)
      {
        pdf:          "#{Seminar.model_name.human}_#{seminar.number}",
        show_as_html: params.key?('debug'),
        # disposition: 'attachment', # default 'inline'
        # template:    'things/show',
        # file:        "#{Rails.root}/files/foo.erb",
        # layout:      'pdf', # for a pdf.pdf.erb file
        # wkhtmltopdf: '/usr/local/bin/wkhtmltopdf', # path to binary
        # orientation: 'Landscape', # default Portrait
        # page_size:   'A4, Letter, ...', # default A4
        # page_height:                    NUMBER,
        # page_width:                     NUMBER,
        # save_to_file: Rails.root.join('pdfs', "#{filename}.pdf"),
        # save_only:    false, # depends on :save_to_file being set first
        # default_protocol: 'http',
        # proxy:            'TEXT',
        # basic_auth:       false, # when true username & password are automatically sent from session
        # username: 'TEXT',
        # password: 'TEXT',
        # title:    'Alternate Title', # otherwise first page title is used
        # cover:            'URL, Pathname, or raw HTML string',
        # dpi:              'dpi',
        # encoding:         'TEXT',
        # user_style_sheet: 'URL',
        # cookie:           ['_session_id SESSION_ID'], # could be an array or a single string in a 'name value' format
        # post: ['query QUERY_PARAM'], # could be an array or a single string in a 'name value' format
        # redirect_delay:                 NUMBER,
        # javascript_delay:               NUMBER,
        # window_status: 'TEXT', # wait to render until some JS sets window.status to the given string
        # image_quality:                  NUMBER,
        # no_pdf_compression: true,
        # zoom:                           FLOAT,
        # page_offset:                    NUMBER,
        # book:                    true,
        # default_header:          true,
        # disable_javascript:      false,
        # grayscale:               true,
        # lowquality:              true,
        # enable_plugins:          true,
        # disable_internal_links:  true,
        # disable_external_links:  true,
        # print_media_type:        true,
        # disable_smart_shrinking: true,
        # use_xserver:             true,
        # background:              false, # background needs to be true to enable background colors to render
        # no_background: true,
        # viewport_size: 'TEXT', # available only with use_xserver or patched QT
        # extra: '', # directly inserted into the command to wkhtmltopdf
        # raise_on_all_errors: nil, # raise error for any stderr output.  Such as missing media, image assets
        # outline: {
        #   outline:       true,
        #   outline_depth: LEVEL
        # },
        margin:  {
          top: 30, # default 10 (mm)
          bottom: 30,
          left:   10,
          right:  10
        },
        header:  {
          html:      {
            template: 'pdf/header', # use :template OR :url
            # layout: 'pdf_plain', # optional, use 'pdf_plain' for a pdf_plain.html.pdf.erb file, defaults to main layout
            # url:    'www.example.com',
            # locals: { foo: @bar }
          },
          # center:    'TEXT',
          # font_name: 'NAME',
          # font_size: SIZE,
          # left:      'TEXT',
          # right:     'TEXT',
          # spacing:   REAL,
          # line:      true,
          # content:   '<h1>Hallo</h1>' # optionally you can pass plain html already rendered (useful if using pdf_from_string)
        },
        footer:  {
          html: {
            template: 'pdf/footer', # use :template OR :url
            # layout: 'pdf_plain.html', # optional, use 'pdf_plain' for a pdf_plain.html.pdf.erb file, defaults to main layout
            # url:    'www.example.com',
            # locals: { foo: @bar }
          },
          # center:    'TEXT',
          # font_name: 'NAME',
          # font_size: 8,
          # left:      'TEXT',
          # right:     'TEXT',
          # spacing:   REAL,
          # line:      true,
          # content:   'HTML CONTENT ALREADY RENDERED'  # optionally you can pass plain html already rendered (useful if using pdf_from_string)
        },
        # toc: {
        #   font_name:            "NAME",
        #   depth:                LEVEL,
        #   header_text:          "TEXT",
        #   header_fs:            SIZE,
        #   text_size_shrink:     0.8,
        #   l1_font_size:         SIZE,
        #   l2_font_size:         SIZE,
        #   l3_font_size:         SIZE,
        #   l4_font_size:         SIZE,
        #   l5_font_size:         SIZE,
        #   l6_font_size:         SIZE,
        #   l7_font_size:         SIZE,
        #   level_indentation:    NUM,
        #   l1_indentation:       NUM,
        #   l2_indentation:       NUM,
        #   l3_indentation:       NUM,
        #   l4_indentation:       NUM,
        #   l5_indentation:       NUM,
        #   l6_indentation:       NUM,
        #   l7_indentation:       NUM,
        #   no_dots:              true,
        #   disable_dotted_lines: true,
        #   disable_links:        true,
        #   disable_toc_links:    true,
        #   disable_back_links:   true,
        #   xsl_style_sheet:      'file.xsl' # optional XSLT stylesheet to use for styling table of contents
        # }
      }
    end
  end
end
