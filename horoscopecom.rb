
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