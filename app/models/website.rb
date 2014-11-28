require 'uri'

class Website < ActiveRecord::Base

  attr_accessor :last_synchronized_at

  validates_presence_of :url
  before_save :shorten_url

  def display_url
    self.url
  end

  def self.new_websites(synchronized_at = nil)
    if synchronized_at.present?
      Website.where('id > ?', synchronized_at).order('created_at DESC')
    else
      Website.all.order('created_at DESC')
    end
  end

  def self.last_synchronized_at
    if Website.last.present?
      return Website.last.id
    else
      return 0
    end
  end
  
  private

    def shorten_url
      uri = URI.parse(url)
      uri = URI.parse("http://#{url}") if uri.scheme.nil?
      host = uri.host.downcase
      self.url = host.start_with?('www.') ? host[4..-1] : host
      self.url += ":#{uri.port}" if uri.port != 80
    end

end
