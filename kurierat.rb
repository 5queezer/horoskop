
def kurierat(zodiac)
    zodiacs = %w{widder stier zwillinge krebs loewe jungfrau waage skorpion schuetze steinbock wassermann fische}
    zodiacs &= zodiac unless zodiac.first == "all"
    abort("Invalid zodiac '#{zodiac.join(',')}'") if zodiacs.empty?
  
    result = {}
  
    zodiacs.each do |zodiac|
      doc = Nokogiri::HTML(open("https://kurier.at/horoskop/#{zodiac}/tag"))

      contents = doc.xpath('/html/body/app/leftlayout/main/horoscope/section/section[1]/div/horoscopehomecenter/div/div/div[3]/div/accordeon[1]/div[2]/div/ul/li').children

      titles = contents.css('.zodiacDetail-accordeon-title').map { |t| t.text.strip }
      paragraphs = contents.css('.zodiacDetail-accordeon-paragraph').map { |t| t.text.strip }

      result[zodiac.to_sym] = {
        :date => DateTime.now.to_date,
        :areas => Hash[titles.zip(paragraphs)] 
      }
    end
    result
  end

  