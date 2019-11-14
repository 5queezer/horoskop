
def horoscopecom(zodiac)
    zodiacs = %w{widder stier zwillinge krebs loewe jungfrau waage skorpion schuetze steinbock wassermann fische}
    zodiacs &= zodiac unless zodiac.first == "all"
    abort("Invalid zodiac '#{zodiac.join(',')}'") if zodiacs.empty?
  
    result = {}
  
    zodiacs.each_with_index do |zodiac,idx|
      doc = Nokogiri::HTML(open("https://www.horoscope.com/us/horoscopes/general/horoscope-general-daily-today.aspx?sign=#{idx+1}"))
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