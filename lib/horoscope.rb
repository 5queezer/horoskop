require 'work_queue'

class Horoscope
  attr_reader :z_map
  attr_accessor :data, :selected_zodiacs
  ZODIACS = %w{aries taurus gemini cancer leo virgio libra scorpio sagittarius capricorn aquarius pisces}
  @@connections = 0
  @@terminations = 0

  def initialize(zodiacs)
    @data = {}
    @selected_zodiacs = zodiacs.join == "all" ? ZODIACS : zodiacs & ZODIACS
  end

  def download
    raise "download needs to be implemented"
  end

  def contents
    download if data.empty?
    @data
  rescue SocketError => e
    $stderr.puts self.class.name << ": " << e.message
  end

  def zodiacs
    @selected_zodiacs.map{ |z| @z_map[z] }.zip(@selected_zodiacs)
  end

  def open_url(*args)
    @@connections += 1
    contents = open(*args)
  end
end