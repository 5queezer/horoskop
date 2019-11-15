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
  attr_accessor :data, :selected_zodiacs
  @@ZODIACS = %w{aries taurus gemini cancer leo virgio libra scorpio sagittarius capricorn aquarius pisces}

  def initialize(zodiacs)
    @data = {}
    @selected_zodiacs = zodiacs.join == "all" ? @@ZODIACS : zodiacs & @@ZODIACS
    raise ArgumentError.new("zodiacs '#{zodiacs.join(', ')}' not found") if @selected_zodiacs.empty?
  end

  def download
    raise "download needs to be implemented"
  end

  def contents
    download if data.empty?
    @data
  end

  def zodiacs
    @selected_zodiacs.map{ |z| @z_map[z] }.zip(@selected_zodiacs)
  end
end

require_relative 'astrowoche'
require_relative 'astroportal'
require_relative 'kroneat'
require_relative 'kurierat'
require_relative 'horoscopecom'
providers = {
  :kurier => KurierAt,
  :krone => KroneAt,
  :horoscopecom => HoroscopeCom,
  :astroportal => Astroportal,
  :astrowoche => Astrowoche
}

opts = Optimist::options do
  opt :zodiac, "Choose zodiac", :type => :string, :default => "all"       
end

zodiacs = opts[:zodiac].split(',')

threads = []

providers.each do |_label, klass|
  threads << Thread.new {
    horoscope = klass.new(zodiacs)
    puts horoscope.contents.to_yaml
  }
end

threads.each(&:join)
