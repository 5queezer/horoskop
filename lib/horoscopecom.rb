class HoroscopeComHoroscope < Horoscope
  def initialize(zodiacs)
    @z_map = Hash[@@ZODIACS.zip(1..12)]
    super(zodiacs)
  end

  def download
    zodiacs.each do |zodiac_id, zodiac_en|
      url = "https://www.horoscope.com/us/horoscopes/general/horoscope-general-daily-today.aspx?sign=#{zodiac_id}"
      doc = Nokogiri::HTML(open(url))
      lang = doc.at('html')['lang']
      contents = doc.css('.main-horoscope > p:nth-child(2)').children
      date_string = contents.at_css('strong').text.strip

      body = contents.text.strip.gsub("#{date_string} - ", '')

      @data[zodiac_en.to_sym] = {
        :url => url,
        :lang => lang,
        :date => Date.parse(date_string),
        :body => body 
      }
    end
  end
end
