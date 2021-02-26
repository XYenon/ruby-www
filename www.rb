require 'net/http'
require 'uri'

class MyHttp
  def initialize(prefix = 'www')
    @prefix = prefix
  end

  def /(other)
    uri = URI("https://#{@prefix}/#{other}")
    Net::HTTP.get_response(uri)
  end

  def respond_to_missing?
    true
  end

  def method_missing(name)
    new_prefix = "#{@prefix}.#{name}"
    if block_given?
      uri = URI("https://#{new_prefix}")
      yield Net::HTTP.get_response(uri)
    else
      MyHttp.new(new_prefix)
    end
  end
end

www = MyHttp.new
www.github.com do |res|
  p "#{res.code} #{res.message}"
  # p res.body
end

api = MyHttp.new('api')
res = api.github.com/'repos/XYenon/ruby-www'
p "#{res.code} #{res.message}"
p res.body
