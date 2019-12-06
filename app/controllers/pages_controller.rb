class PagesController < ApplicationController

  def home
    redirect_to :admin_root if current_user
  end

  def show
    slug = [params[:path1], params[:path2], params[:path3]].select(&:present?).join('/')
    static_page = "pages/static/#{slug}"
    return render static_page if lookup_context.find_all(static_page).any?

    @page = Page.published.find_by! slug: slug
  end
end
