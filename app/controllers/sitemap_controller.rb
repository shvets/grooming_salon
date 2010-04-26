class SitemapController < ApplicationController
  def index
    expires_in 30.minutes, :public => true
    Sitemap::Routes.parse
    respond_to do |format|
      format.xml do
        render :xml => Sitemap::Routes.results.to_xml
      end
    end
  end
end
