module IconHelper
  def locations_icon(text = nil)
    fa_icon 'map-marker', text: text
  end

  def invoice_icon(text = nil)
    fa_icon 'file', text: text
  end

end
