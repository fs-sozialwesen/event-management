module Api
  class BaseController < ApplicationController

    protected

    helper_method def cache_time
      1.hour
    end

  end
end
