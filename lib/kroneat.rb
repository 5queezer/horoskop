class KroneHoroscope < Horoscope
  def initialize(zodiacs)
    @z_map = Hash[@@ZODIACS.zip(%w{widder stier zwillinge krebs loewe jungfrau waage skorpion schuetze steinbock wassermann fische})]
    super(zodiacs)
  end

  def download
    zodiacs.each do |zodiac_id, zodiac_en|
      url = "https://www.krone.at/horoskop-#{zodiac_id}"
      doc = Nokogiri::HTML(open(url))
      lang = doc.at('html')['lang']
      date_string = doc.css('.daily-horoscope-content__date').text.gsub(/[^\d.]*/, '')
      date = Date.strptime(date_string, '%d.%m.%Y')
      contents = doc.css('.daily-horoscope-content__text').children
    
      body = {}
      contents.each do |paragraph|
        area = paragraph.css('strong').text.strip.gsub(':', '')
        body[area] = paragraph.text.gsub( /#{area}:/, '').strip
      end

      @data[zodiac_en.to_sym] = {
        :url => url,
        :lang => lang,
        :date => date,
        :body => body 
      }
    end
  end


end
