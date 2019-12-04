class SeminareController < ApplicationController

  def index
    redirect_to 'https://www.pbw-lsa.de/fort_weiterbildung/seminare/'
  end

  def home
    redirect_to 'https://www.pbw-lsa.de/fort_weiterbildung/seminare/'
  end

  def show
    redirect_to "https://www.pbw-lsa.de/seminar/detail/#{params[:id]}/"
  end

  def search
    redirect_to 'https://www.pbw-lsa.de/fort_weiterbildung/seminare/'
  end
end
