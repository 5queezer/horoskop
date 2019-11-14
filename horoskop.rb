#!/usr/bin/ruby -W1

require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'
require 'pp'
require 'optimist'
require 'yaml'
require 'date'
require_relative 'date_german_additions'
require_relative 'astrowoche'
require_relative 'astroportal'
require_relative 'kroneat'

opts = Optimist::options do
  opt :zodiac, "Choose zodiac", :type => :string, :default => "all"       
end

# zodiacs_en = %w{aries taurus gemini cancer leo virgo libra scorpio saggitarius capricorn aquarius pisces}

contents = kroneat opts[:zodiac].split(',')
puts contents.to_yaml

contents = astroportal opts[:zodiac].split(',')
puts contents.to_yaml

contents = astrowoche opts[:zodiac].split(',')
puts contents.to_yaml
 
# astrowoche.each do |zodiac|
#    pp zodiac
# end
