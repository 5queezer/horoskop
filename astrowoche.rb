
def astrowoche(zodiac)
  zodiacs = %w{widder stier zwillinge krebs loewe jungfrau waage skorpion schuetze steinbock wassermann fische}
  zodiacs &= zodiac unless zodiac.first == "all"
  abort("Invalid zodiac '#{zodiac.join(',')}'") if zodiacs.empty?

  result = {}

  zodiacs.each do |zodiac|
    doc = Nokogiri::HTML(open("https://astrowoche.wunderweib.de/tageshoroskop/heute/#{zodiac}"))
    date_string = doc.css('h1.article-header__headline.typo--headline-big').text.gsub(/[^\d.]*/, '')
    date = Date.strptime(date_string, '%d.%m.%Y')
    result[zodiac.to_sym] = {
      :date => date,
      :tagline => doc.xpath('//article/div[@class="typo--editor"]/h2').text,
      :day_times => doc.xpath('//article/div[@class="typo--editor"]/h3').map {|title| { title.text => title.next.next.text.strip} }
    }
  end
  result
end