class AstroportalHoroscope < Horoscope
  def initialize(zodiacs)
    @z_map = Hash[ZODIACS.zip(%w{widder stier zwillinge krebs loewe jungfrau waage skorpion schuetze steinbock wassermann fische})]
    super(zodiacs)
  end

  def download
    zodiacs.each do |zodiac_id, zodiac_en|
      url = "https://www.astroportal.com/tageshoroskope/#{zodiac_id}"
      doc = Nokogiri::HTML(open_url(url, :allow_redirections => :all))

      lang = doc.at('html')['lang']
      date_string = doc.css('#c23 > div:nth-child(1) > h2:nth-child(6)').text.strip.gsub(/^.*, /, '')
      date = Date.parse_german_string(date_string)

      @data[zodiac_en.to_sym] = {
        :url => url,
        :lang => lang,
        :date => date,
        :title => doc.css('h3.blue').text.strip,
        :body => doc.css('#c23 > div:nth-child(1) > p:nth-child(10)').text.strip
      }
    end
  end
end
