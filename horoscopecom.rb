class HoroscopeCom < Horoscope
  def initialize(zodiacs)
    @z_map = Hash[@@ZODIACS.zip(1..12)]
    super(zodiacs)
  end

  def download
    zodiacs.each do |zodiac_id, zodiac_en|
      url = "https://www.horoscope.com/us/horoscopes/general/horoscope-general-daily-today.aspx?sign=#{zodiac_id}"
      doc = Nokogiri::HTML(open(url))
      contents = doc.css('.main-horoscope > p:nth-child(2)').children
      date_string = contents.css('strong').text.strip

      body = contents.text.strip.gsub("#{date_string} - ", '')

      @data[zodiac_en.to_sym] = {
        :url => url,
        :date => Date.parse(date_string),
        :body => body 
      }
    end
  end
end

def horoscopecom(zodiac)
  # TODO bugfix index in url
    zodiacs = %w{widder stier zwillinge krebs loewe jungfrau waage skorpion schuetze steinbock wassermann fische}
    zodiac_map = Hash[zodiacs.zip 1..12]
    zodiacs &= zodiac unless zodiac.first == "all"
    abort("Invalid zodiac '#{zodiac.join(',')}'") if zodiacs.empty?
  
    result = {}
  
    zodiacs.each do |zodiac|
      doc = Nokogiri::HTML(open("https://www.horoscope.com/us/horoscopes/general/horoscope-general-daily-today.aspx?sign=#{zodiac_map[zodiac]}"))
      contents = doc.css('.main-horoscope > p:nth-child(2)').children
      date_string = contents.css('strong').text.strip

      body = contents.text.strip.gsub("#{date_string} - ", '')

      result[zodiac.to_sym] = {
        :date => Date.parse(date_string),
        :body => body 
      }
    end
    result
  end