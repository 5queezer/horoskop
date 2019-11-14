#!/usr/bin/ruby -W1

require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'
require 'pp'
require 'optimist'
require 'yaml'
require 'date'
require_relative 'date_german_additions'

class Horoscope
  attr_reader :z_map
  attr_accessor :data
  @@ZODIACS = %w{aries taurus gemini cancer leo virgio libra scorpio sagittarius capricorn aquarius pisces}

  def initialize(zodiacs)
    @data = {}
    @selected_zodiacs = zodiacs & @@ZODIACS
    raise ArgumentError.new("zodiacs '#{zodiacs.join(', ')}' not found") if @selected_zodiacs.empty?
  end

  def download
    raise "download needs to be implemented"
  end

  def contents
    download if data.empty?
    @data
  end

  def mapped_zodiac(zodiac)
    @z_map[zodiac]
  end
end

require_relative 'astrowoche'
require_relative 'astroportal'
require_relative 'kroneat'
require_relative 'kurierat'
require_relative 'horoscopecom'

opts = Optimist::options do
  opt :zodiac, "Choose zodiac", :type => :string, :default => "all"       
end

zodiacs = opts[:zodiac].split(',')

k = KurierAt.new(zodiacs)
puts k.contents

# threads = []
# threads << Thread.new {
#   contents = kurierat opts[:zodiac].split(',')
#   puts contents.to_yaml
# }

# threads << Thread.new {
#   contents = kroneat opts[:zodiac].split(',')
#   puts contents.to_yaml
# }

# threads << Thread.new {
#   contents = astroportal opts[:zodiac].split(',')
#   puts contents.to_yaml
# }

# threads << Thread.new {
#   contents = astrowoche opts[:zodiac].split(',')
#   puts contents.to_yaml
# }

# threads << Thread.new {
#   contents = horoscopecom opts[:zodiac].split(',')
#   puts contents.to_yaml
# }

# threads.each(&:join) 


