class Horoscope
  attr_reader :z_map
  attr_accessor :data, :selected_zodiacs
  ZODIACS = %w{aries taurus gemini cancer leo virgio libra scorpio sagittarius capricorn aquarius pisces}

  def initialize(zodiacs)
    @data = {}
    @selected_zodiacs = zodiacs.join == "all" ? ZODIACS : zodiacs & ZODIACS
    raise ArgumentError.new("zodiacs '#{zodiacs.join(', ')}' not found") if @selected_zodiacs.empty?
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
end