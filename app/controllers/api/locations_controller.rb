module Api
  class LocationsController < BaseController

    def index
      @locations = Location.all

      expires_in cache_time, public: true
      stale? @locations
    end

  end
end
