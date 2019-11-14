def astroportal(zodiac)
    zodiacs = %w{widder stier zwillinge krebs loewe jungfrau waage skorpion schuetze steinbock wassermann fische}
    zodiacs &= zodiac unless zodiac.first == "all"
    abort("Invalid zodiac '#{zodiac.join(',')}'") if zodiacs.empty?

    result = {}

    zodiacs.each do |zodiac|
        doc = Nokogiri::HTML(open("https://www.astroportal.com/tageshoroskope/#{zodiac}", :allow_redirections => :all))
        date_string = doc.css('#c23 > div:nth-child(1) > h2:nth-child(6)').text.strip.gsub(/^.*, /, '')
        date = Date.parse_german_string(date_string)

        result[zodiac.to_sym] = {
          :date => date,
          :tagline => doc.css('h3.blue').text.strip,
          :body => doc.css('#c23 > div:nth-child(1) > p:nth-child(10)').text.strip
        }
      end
      result
end

