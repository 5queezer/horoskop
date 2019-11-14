
def kroneat(zodiac)
    zodiacs = %w{widder stier zwillinge krebs loewe jungfrau waage skorpion schuetze steinbock wassermann fische}
    zodiacs &= zodiac unless zodiac.first == "all"
    abort("Invalid zodiac '#{zodiac.join(',')}'") if zodiacs.empty?
  
    result = {}
  
    zodiacs.each do |zodiac|
      doc = Nokogiri::HTML(open("https://www.krone.at/horoskop-#{zodiac}"))
      date_string = doc.css('.daily-horoscope-content__date').text.gsub(/[^\d.]*/, '')
      date = Date.strptime(date_string, '%d.%m.%Y')

      contents = doc.css('.daily-horoscope-content__text').children
    
      areas = {}
      contents.each do |paragraph|
        area = paragraph.css('strong').text.strip.gsub(':', '')
        areas[area] = paragraph.text.gsub( /#{area}:/, '').strip
      end

      result[zodiac.to_sym] = {
        :date => date,
        :areas => areas 
      }
    end
    result
  end