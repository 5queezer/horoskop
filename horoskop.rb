#!/usr/bin/ruby -W1

require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'
require 'pp'
require 'optimist'
require 'yaml'
require 'date'
require_relative 'lib/date_german_additions'

require_relative 'lib/horoscope'
require_relative 'lib/astrowoche'
require_relative 'lib/astroportal'
require_relative 'lib/kroneat'
require_relative 'lib/kurierat'
require_relative 'lib/horoscopecom'
require_relative 'lib/rogers'

available_horoscopes = ObjectSpace.each_object(Class).select do |c| 
  c.inspect.end_with? "Horoscope" and c.inspect != "Horoscope"
end

available_horoscope_array = available_horoscopes.map{ |h| h.inspect.delete_suffix('Horoscope').downcase }

opts = Optimist::options do
  opt :zodiac, "Zodiacs, comma separated", :default => Horoscope::ZODIACS.join(',')
  opt :provider, "Provider, comma separated", :default => available_horoscope_array.join(',')
end

zodiac_array = opts[:zodiac].split(',')
zodiacs = zodiac_array & Horoscope::ZODIACS
raise "zodiac(s) not found: #{ (zodiac_array - zodiacs).join(',') }" if zodiacs.length != zodiac_array.length

threads = []
results = {}

provider_array = opts[:provider].downcase.split(',')
available_horoscopes.each do |klass|
  provider = klass.inspect.delete_suffix('Horoscope')
  next unless provider_array.include? provider.downcase 

  threads << Thread.new do
    horoscope = klass.new(zodiacs)
    results[provider.to_sym] = horoscope.contents
  end
end

threads.each(&:join)

output = {}
zodiacs.each do |zodiac|
  output[zodiac] = {}
  results.each do |res|
    provider, data = *res
    contents = data[zodiac.to_sym]
    output[zodiac][provider] = contents.slice(:date, :title, :body)
  end
end

puts (zodiacs.length == 1 ? output.first[1] : output).to_yaml

