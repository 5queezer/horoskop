class KurierHoroscope < Horoscope
  def initialize(zodiacs)
    @z_map = Hash[@@ZODIACS.zip(%w{widder stier zwillinge krebs loewe jungfrau waage skorpion schuetze steinbock wassermann fische})]
    super(zodiacs)
  end

  def download
    zodiacs.each do |zodiac_id, zodiac_en|
      url = "https://kurier.at/horoskop/#{zodiac_id}/tag"
      doc = Nokogiri::HTML(open(url))
      lang = doc.at('html')['lang']
      contents = doc.xpath('/html/body/app/leftlayout/main/horoscope/section/section[1]/div/horoscopehomecenter/div/div/div[3]/div/accordeon[1]/div[2]/div/ul/li').children
      titles = contents.css('.zodiacDetail-accordeon-title').map { |t| t.text.strip }
      paragraphs = contents.css('.zodiacDetail-accordeon-paragraph').map { |t| t.text.strip }

      @data[zodiac_en.to_sym] = {
        :url => url,
        :lang => lang,
        :date => DateTime.now.to_date,
        :body => Hash[titles.zip(paragraphs)] 
      }
    end
  end
end


  