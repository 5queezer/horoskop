class Sat1Horoscope < Horoscope
  def initialize(zodiacs)
    @z_map = Hash[ZODIACS.zip(%w{widder stier zwillinge krebs loewe jungfrau waage skorpion schuetze steinbock wassermann fische})]
    super(zodiacs)
  end

  def download
    zodiacs.each do |zodiac_id, zodiac_en|
      url = "https://www.sat1.de/ratgeber/horoskop/tageshoroskop/#{zodiac_id}"
      doc = Nokogiri::HTML(open_url(url))

      lang = doc.at('html')['lang']
      content = doc.at_css('.formatted-text')
      encode = lambda { |text| text.encode("iso-8859-1").force_encoding("utf-8") }
      titles = content.css('h3').map { |t| encode[t.text.strip] }
      paragraphs = content.css('p').map{ |t| encode[t.text.strip] }
  
      date_string = doc.at('/html/head/meta[@property="article:modified_time"]')['content']
      date = Date.parse date_string
      @data[zodiac_en.to_sym] = {
        :url => url,
        :lang => lang,
        :date => date,
        :body => Hash[titles.zip(paragraphs)] 
      }
    end
  end
end
