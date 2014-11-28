class WebsitesController < ApplicationController

  def index
    @website = Website.new
    @website.last_synchronized_at = Website.last_synchronized_at
    @websites_content = Website.new_websites.map{|website| render_to_string(:partial => '/websites/item', locals: {website: website}) }.join('')
  end

  def refresh
    Rails.logger.debug "params[:last_synchronized_at]: #{params[:last_synchronized_at]}"
    @last_synchronized_at = params[:last_synchronized_at].to_s.to_i rescue nil
    respond_to do |format|
      format.js {
        if @last_synchronized_at.present?
          @websites_content = Website.new_websites(@last_synchronized_at).map{|w| render_to_string(:partial => '/websites/item', locals: {website: w}) }.join('')
        end
      }
    end
  end

  def create
    @website = Website.new(website_params)
    @website.save if @website.valid?
    
    respond_to do |format|
      format.js {
        if @website.valid?
          @websites_content = Website.new_websites(@website.last_synchronized_at).map{|w| render_to_string(:partial => '/websites/item', locals: {website: w}) }.join('')
        end
      }
    end
  end

  private
    def website_params
      params.require(:website).permit(:url, :last_synchronized_at)
    end
end
