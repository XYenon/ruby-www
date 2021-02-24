require 'net/http'
require 'uri'

class MyHttp
  def initialize(prefix = 'www')
    @prefix = prefix
  end

  def respond_to_missing?
    true
  end

  def method_missing(name)
    if block_given?
      uri = URI("https://#{@prefix}.#{name}")
      yield Net::HTTP.get_response(uri)
    else
      MyHttp.new("#{@prefix}.#{name}")
    end
  end
end

www = MyHttp.new
www.cloudflare.com do |res|
  p "#{res.code} #{res.message}"
  # p res.body
end

dash = MyHttp.new('dash')
dash.cloudflare.com do |res|
  p "#{res.code} #{res.message}"
  # p res.body
end
