class RogersHoroscope < Horoscope
  def initialize(zodiacs)
    @z_map = Hash[ZODIACS.zip(%w{widder stier zwillinge krebs loewe jungfrau waage skorpion schuetze steinbock wassermann fische})]
    super(zodiacs)
  end

  def download
    zodiacs.each do |zodiac_id, zodiac_en|
      url = "https://www.rogers.at/horoskop-online/#{zodiac_id}/"
      doc = Nokogiri::HTML(open_url(url))

      lang = doc.at('html')['lang']
      contents = doc.at('div.av-layout-tab:nth-child(3) > div:nth-child(1) > div:nth-child(1) > section:nth-child(1) > div:nth-child(1)')
      date_string = doc.css('span.today').text.strip
      body = Hash[doc.css('h3')[0..2].map{ |title| title.text.strip }.zip(doc.css('p:not(:empty)')[0..2].map{ |description| description.text.strip })]

      @data[zodiac_en.to_sym] = {
        :url => url,
        :lang => lang,
        :date => Date.parse(date_string),
        :body => body,
      }
    end
  end
end
