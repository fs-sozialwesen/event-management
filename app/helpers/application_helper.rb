module ApplicationHelper

  def lines_for(values, delimiter: '<br>')
    values.select(&:present?).join(delimiter).html_safe
  end

  def gmaps_link(obj)
    ['https://maps.google.de?q=', obj.street, obj.zip, obj.city].join(' ')
  end

  def bool_icon(val, yes_title = 'yes', no_title = 'no')
    label, icon, title =
      case val
      when true  then ['success', 'check',    yes_title]
      when false then ['danger',  'minus',    no_title]
      else            ['default', 'question', '']
      end

    content_tag(:span, class: 'label label-' + label, title: title) { fa_icon icon }
  end

  def ldate(date, options = nil)
    return '' unless date.present?
    return ldates date.begin, date.end, options if date.is_a?(Range)
    I18n.l date, options
  end

  def ldates(start_date, end_date, options = nil)
    # sep    = start_date == end_date.yesterday ? '/' : '-'
    sep    = '-'
    format = format_for start_date, end_date
    [ldate(start_date, format: format), sep, ldate(end_date, options)].join
  end

  def format_for(start_date, end_date)
    return '%d.%m.%Y' if start_date.year  != end_date.year
    return '%d.%m.'   if start_date.month != end_date.month
    '%d.'
  end

  def panel_box(title: nil, css_class: '', &block)
    content = capture(&block)
    content_tag(:div, class: "panel panel-default #{css_class}") do
      head = panel_heading title: title
      body = content_tag(:div, content, class: 'panel-body')
      [head, body].join.html_safe
    end
  end

  def panel_box_with_table(title: nil, css_class: '', &block)
    content = capture(&block)
    content_tag(:div, class: "panel panel-default #{css_class}") do
      head = panel_heading title: title
      [head, content].join.html_safe
    end
  end

  def panel_heading(title: nil, buttons: nil)
    return unless title
    content_tag(:div, class: 'panel-heading') do
      content_tag(:h4, title, class: 'panel-title')
    end
  end

  def tax_price(price)
    price = Money.from_amount price unless price.is_a? Money
    content_tag(:span, number_with_delimiter(price.exchange_to('EU4TAX').exchange_to('EURTAX')), class: 'tax', title: 'brutto')
  end

  def nontax_price(price)
    price = Money.from_amount price unless price.is_a? Money
    content_tag(:span, number_with_delimiter(price.exchange_to('EU4NET').exchange_to('EURNET')), class: 'nontax', title: 'netto')
  end

  def list_link(url)
    link_to fa_icon('chevron-left', text: t(:list)), url, class: 'btn btn-default'
  end

  def new_link(url, primary: true, label: t(:new), options: {})
    css = primary ? 'btn btn-primary' : 'btn btn-default'
    options[:class] = css + ' hidden-print'
    link_to fa_icon('plus', text: label), url, options
  end

  def edit_link(url, **options)
    options[:class] ||= ''
    options[:class] += ' btn btn-primary edit'
    link_to fa_icon('pencil', text: t(:edit)), url, options
  end

  def copy_link(url, **options)
    options[:class] ||= ''
    options[:class] += ' btn btn-default'
    link_to fa_icon('clone', text: t(:copy)), url, options
  end

  def pdf_link(url, text: 'PDF', css_class: 'btn btn-default')
    link_to fa_icon('file-pdf-o', text: text), url, class: css_class, target: '_blank'
  end

  def delete_link(record, scope: nil)
    label = fa_icon 'trash', text: t(:delete)
    confirm = t(:confirm_delete, model: record.class.model_name.human)
    url = scope ? [scope, record] : record
    link_to label, url, method: :delete, data: { confirm: confirm }, class: 'btn btn-danger'
  end

  def page_title_for(record_or_collection, attr = nil)
    title = title_for record_or_collection, attr, with_icon: false, with_model: false, counts: false
    content_for :title, title
  end

  def title_for(record_or_collection, attr = nil, with_icon: true, with_model: true, counts: true, count: nil)
    title = if record_or_collection.is_a? ActiveRecord::Relation
      collection_title_for(record_or_collection, counts: counts, count: count)
    else
      member_title_for(record_or_collection, attr, with_model: with_model)
    end
    title = icon_for record_or_collection, text: title if with_icon
    title
  end

  def title_for_model(model, count: 2, with_icon: false)
    title = model.model_name.human count: count
    title = icon_for model, text: title if with_icon
    title
  end

  def icon_for(model_or_record, text: '', size: nil)
    model = model_or_record.is_a?(ActiveRecord::Base) ? model_or_record.class : model_or_record
    icon  = t("#{model.model_name.name.tableize}.icon")
    icon  = "#{icon} #{size}x" if size
    fa_icon icon, text: text
  end

  def model_for_collection(collection)
    collection.class.to_s.split('::').first.constantize
  end

  def collection_title_for(collection, count: nil, counts: true)
    model = model_for_collection collection
    count ||= (collection.respond_to?(:total_count) ? collection.total_count : collection.count)
    title = title_for_model model, count: count
    title = "#{count} #{title}" if counts
    title
  end

  def member_title_for(record, attr = nil, with_model: true)
    return t("admin.#{record.class.model_name.name.tableize}.new.title") if record.new_record?
    attr ||= :name
    if with_model
      [record.send(attr), content_tag(:small, record.class.model_name.human)].join(' ').html_safe
    else
      record.send(attr)
    end
  end

  def cancel_url(record)
    record.new_record? ? record.class : record
  end

  def version_value(value)
    return bool_icon(value)       if value.in? [true, false]
    return ldate(value)           if value.kind_of? Time
    return number_to_human(value) if value.is_a? Float
    return ''                     if value.blank?
    return value.html_safe        if value.is_a?(String)
    value.to_s
  end

  def pras_select(field)
    collection = LegalStatistic::COLLECTIONS[field]
    return collection if collection.is_a? Array
    collection.map { |number, name| ["#{number} - #{name}", number] }
  end

end
