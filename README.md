# Horoskop
Horoscope web scraper

Scrape the content of these web services and output the result as YAML

- Krone.at
- Astroportal
- Astrowoche.de
- Horoscope.com
- Kurier.at
- Rogers.at

## Install
```
git clone git@github.com:5queezer/horoskop.git
cd horoskop
bundle install
```

## Usage:
```
ruby horoskop.rb --zodiac leo,cancer --provider krone
```

Show help
```
ruby horoskop.rb --help
```
