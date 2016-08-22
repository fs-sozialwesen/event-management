class Address < JsonSerializer

  attribute :street,    String
  attribute :zip,       String
  attribute :city,      String

  attribute :location, GeoLocation

  def self.dump(options)
    return options if options.is_a? Hash
    atts = options.attributes.to_h
    atts[:location] = options.location.attributes if options.location
    atts
  end

  def gmaps_search_link
    ['https://maps.google.de?q=', street, zip, city].join(' ')
  end

  module ActsAsAddressable
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods

      def acts_as_addressable(options = {})
        serialize :address, ::Address

        ::Address.attribute_set.each do |attribute|
          delegate attribute.name, to: :address
          delegate "#{attribute.name}=", to: :address
        end
      end
    end
  end

end

