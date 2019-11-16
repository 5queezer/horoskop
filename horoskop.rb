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
require_relative 'lib/sat1'

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
    results[provider] = horoscope.contents
  end
end

threads.each(&:join)

# reformat results for a nice output

reduce = lambda { |arr| arr.length == 1 ? reduce.call(arr.first[1]) : arr }

output = {}
zodiacs.each do |zodiac|
  z = zodiac.to_sym
  output[z] = {}
  results.each do |res|
    provider, data = *res
    contents = data[z]
    output[z][provider] = contents.slice(:date, :title, :body)
  end
  output[z] = reduce[output[z]]
end


puts reduce[output].to_yaml

