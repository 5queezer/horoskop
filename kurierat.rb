class KurierAt < Horoscope
  def initialize(zodiacs)
    @z_map = Hash[@@ZODIACS.zip(%w{widder stier zwillinge krebs loewe jungfrau waage skorpion schuetze steinbock wassermann fische})]
    super(zodiacs)
  end

  def download
    @selected_zodiacs.map{ |z| mapped_zodiac(z) }.each do |zodiac|
      url = "https://kurier.at/horoskop/#{zodiac}/tag"
      doc = Nokogiri::HTML(open(url))
      contents = doc.xpath('/html/body/app/leftlayout/main/horoscope/section/section[1]/div/horoscopehomecenter/div/div/div[3]/div/accordeon[1]/div[2]/div/ul/li').children
      titles = contents.css('.zodiacDetail-accordeon-title').map { |t| t.text.strip }
      paragraphs = contents.css('.zodiacDetail-accordeon-paragraph').map { |t| t.text.strip }

      @data[zodiac.to_sym] = {
        :url => url,
        :date => DateTime.now.to_date,
        :body => Hash[titles.zip(paragraphs)] 
      }
    end
  end
end


  