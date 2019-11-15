class Astrowoche < Horoscope
  def initialize(zodiacs)
    @z_map = Hash[@@ZODIACS.zip(%w{widder stier zwillinge krebs loewe jungfrau waage skorpion schuetze steinbock wassermann fische})]
    super(zodiacs)
  end

  def download
    zodiacs.each do |zodiac_id, zodiac_en|
      url = "https://astrowoche.wunderweib.de/tageshoroskop/heute/#{zodiac_id}"
      doc = Nokogiri::HTML(open(url))

      content = doc.css('section.box--bg-color:nth-child(1) > article:nth-child(1)')
      titles = content.css('.typo--editor > h3').map { |t| t.text.strip }
      paragraphs = content.css('.typo--editor > h3 + p').map{ |t| t.text.strip }
  
      date_string = doc.css('h1.article-header__headline.typo--headline-big').text.gsub(/[^\d.]*/, '')
      date = Date.strptime(date_string, '%d.%m.%Y')
      @data[zodiac_en.to_sym] = {
        :url => url,
        :date => date,
        :title => content.css('.typo--editor > h2:nth-child(1)').text,
        :body => Hash[titles.zip(paragraphs)] 
      }
    end
  end
end


def astrowoche(zodiac)
  zodiacs = %w{widder stier zwillinge krebs loewe jungfrau waage skorpion schuetze steinbock wassermann fische}
  zodiacs &= zodiac unless zodiac.first == "all"
  abort("Invalid zodiac '#{zodiac.join(',')}'") if zodiacs.empty?

  result = {}

  zodiacs.each do |zodiac|
    doc = Nokogiri::HTML(open("https://astrowoche.wunderweib.de/tageshoroskop/heute/#{zodiac}"))

    content = doc.css('section.box--bg-color:nth-child(1) > article:nth-child(1)')
    titles = content.css('.typo--editor > h3').map { |t| t.text.strip }
    paragraphs = content.css('.typo--editor > h3 + p').map{ |t| t.text.strip }

    date_string = doc.css('h1.article-header__headline.typo--headline-big').text.gsub(/[^\d.]*/, '')
    date = Date.strptime(date_string, '%d.%m.%Y')
    result[zodiac.to_sym] = {
      :date => date,
      :tagline => content.css('.typo--editor > h2:nth-child(1)').text,
      :areas => Hash[titles.zip(paragraphs)] 
    }
  end
  result
end