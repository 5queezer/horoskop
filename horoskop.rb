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
  private :data

  def initialize(zodiacs)
    @@ZODIACS = %w{aries taurus gemini cancer leo virgio libra scorpio sagittarius capricorn aquarius pisces}
    @data = {}
  end

  def download
    raise "download needs to be implemented"
  end

  def contents
    self.download if data.empty?
    @data
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


threads = []
threads << Thread.new {
  contents = kurierat opts[:zodiac].split(',')
  puts contents.to_yaml
}

threads << Thread.new {
  contents = kroneat opts[:zodiac].split(',')
  puts contents.to_yaml
}

threads << Thread.new {
  contents = astroportal opts[:zodiac].split(',')
  puts contents.to_yaml
}

threads << Thread.new {
  contents = astrowoche opts[:zodiac].split(',')
  puts contents.to_yaml
}

threads << Thread.new {
  contents = horoscopecom opts[:zodiac].split(',')
  puts contents.to_yaml
}

threads.each(&:join) 


