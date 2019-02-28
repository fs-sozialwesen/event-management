require 'prawn/measurement_extensions'

class InvoicePdf < ApplicationDocument

  include ActionView::Helpers::SanitizeHelper
  include ApplicationHelper

  attr_reader :invoice, :company

  def initialize(invoice)
    @debug         = false
    @margin_top    = 28.mm
    @margin_bottom = 0
    @margin_side   = 28.mm
    @printed_footer = 30.mm
    super(page_size: 'A4', margin: [@margin_top, @margin_side, @margin_bottom + @printed_footer])
    @invoice = invoice
    @seminar = @invoice.seminar.decorate
    @company = OpenStruct.new t('invoices.pdf.company')
    # @header_text_options = { size: 30, style: :italic, align: :center }
    generate
  end

  def filename
    "#{Invoice.model_name.human}_#{invoice.number.sub('/', '-')}.pdf"
  end

  def generate
    stroke_bounds if @debug
    # write_header
    stroke_horizontal_rule if @debug
    # move_down 20

    write_address
    # write_right_box

    write_header_table
    move_down 15
    # write_heading
    text "#{t('invoices.pdf.title')} #{invoice.number}", size: 16
    move_down 10
    text invoice.pre_message, size: 11
    # move_down 4
    write_seminar_box
    move_down 7
    text 'Folgende Teilnehmer/innen sind in dieser Rechnung berücksichtigt:', size: 11
    # move_down 5
    write_positions
    move_down 15
    text invoice.post_message, size: 11
    move_down 10
    # write_footer
    text t('invoices.pdf.footer_message_1'), inline_format: true, size: 10
    image Rails.root.join('public/signature.png')
    text t('invoices.pdf.footer_message_2'), inline_format: true, size: 10
  end

  # def write_header
  #   repeat(:all) do
  #     height = @margin_top / 2
  #     bounding_box [0, bounds.top + height], width: bounds.right, height: height do
  #       text company.name, @header_text_options
  #       # stroke_bounds if @debug
  #     end
  #   end
  # end

  def write_address
    y = bounds.top - (55.mm - @margin_top)
    font_size 11 do
      bounding_box([5, y], width: 90.mm, height: 25.mm) do
        text invoice.address
        stroke_bounds if @debug
      end
    end
  end

  # def write_right_box
  #   font_size 10 do
  #     y      = bounds.top - (55.mm - @margin_top)
  #     height = 30.mm
  #     width  = 70.mm
  #     box_options = { width: width, height: height }
  #
  #     x = bounds.right - width
  #     bounding_box [x, y], box_options do
  #       data = [
  #         [t(:phone), company.phone],
  #         [t(:email), company.email],
  #         [t(:invoice_date), ldate(invoice.date)],
  #       ]
  #       table data, { width: bounds.right, cell_style: { border_width: 0, padding: [1, 5] } }
  #
  #       stroke_bounds if @debug
  #     end
  #   end
  # end

  def write_header_table
    data = [
      ['Ihr Zeichen/Ihre Nachricht vom', 'Unser Zeichen', 'Durchwahl', 'Datum'],
      ['', '', company.phone, ldate(invoice.date)]
    ]
    options = {
      width:      bounds.right,
      cell_style: { border_width: 0, padding: [1, 5] }
    }
    font_size(8) { table data, options }
  end

  def write_seminar_box
    font_size 10 do
      table seminar_data, seminar_table_options do |t|
        t.column(0).font_style = :bold
        t.cells.style { |c| c.align = :left }
      end
    end
  end

  def seminar_data
    [
      [Seminar.human_attribute_name(:title),    @seminar.title],
      [Seminar.human_attribute_name(:number),   @seminar.number],
      [Seminar.human_attribute_name(:events),   @seminar.date_text_or_events],
      [Seminar.human_attribute_name(:location), @seminar.location.name]
    ]
  end

  def seminar_table_options
    indent = 20
    {
      width:         bounds.right - indent,
      column_widths: { 0 => 120 },
      cell_style:    { borders: [:top, :bottom], border_width: 0, padding: [1, 5] },
      position:      indent
    }
  end

  def write_positions
    indent(20, 40) do
      font_size 10 do
        table positions_array, positions_table_options do |t|
          t.row(-1).font_style = :bold
          t.cells.style { |c| c.align = :right if c.column == 1 }
        end
      end
    end
  end

  def positions_array
    # [%w(Teilnehmer Gebühr)] + invoice.items.map { |item| [item.attendee, display_price(item.price)] }
    invoice.items.map { |item| [item.attendee, display_price(item.price)] } +
        [['Gesamtgebühr', display_price(invoice.items.sum)]]
  end

  def positions_table_options
    {
      row_colors:    %w( FFFFFF EEEEEE),
      # header:        false,
      width:         bounds.right,
      column_widths: { 1 => 120 },
      cell_style:    { borders: [:top, :bottom], border_width: 0.2, border_lines: [:solid, :dashed], padding: [2, 5] }
    }
  end

end
