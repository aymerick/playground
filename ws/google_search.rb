# encoding: utf-8

#
# Quick and dirty code to search for Williams Syndrome references all around the world
#

require 'rubygems'
require 'nokogiri'
require 'cgi'
require 'open-uri'
require 'pp'

DEBUG = false

SYNDROME_TRANSLATIONS = {
  'af' => 'Williams sindroom',
  'ar' => 'متلازمة وليامز',
  'az' => 'williams sindromu',
  'be' => 'сіндромам Вільямса',
  'bg' => 'синдром на Уилямс',
  'bn' => 'উইলিয়ামস সিন্ড্রোম',
  'bs' => 'Williams sindrom',
  'ca' => 'síndrome de williams',
  'ceb' => 'Williams syndrome',
  'cs' => 'Williams syndrom',
  'cy' => 'syndrom williams',
  'da' => 'williams syndrom',
  'de' => 'williams-Syndrom',
  'el' => 'Το σύνδρομο Ουίλιαμς',
  'en' => 'williams syndrome',
  'eo' => 'Williams sindromo',
  'es' => 'síndrome de williams',
  'et' => 'Williamsi sündroom',
  'eu' => 'williams sindromea',
  'fa' => 'سندرم ویلیامز',
  'fi' => 'Williams oireyhtymä',
  'fr' => 'syndrome de Williams',
  'ga' => 'siondróm Williams',
  'gl' => 'síndrome de Williams',
  'gu' => 'વિલિયમ્સ સિન્ડ્રોમ',
  'ha' => 'Williams ciwo',
  'hi' => 'विलियम्स सिंड्रोम',
  'hmn' => 'Williams syndrome',
  'hr' => 'Williams sindrom',
  'ht' => 'sendwòm Williams',
  'hu' => 'Williams-szindróma',
  'hy' => 'WILLIAMS սինդրոմը',
  'id' => 'sindrom williams',
  'ig' => 'Williams ọrịa',
  'is' => 'Williams heilkenni',
  'it' => 'sindrome di Williams',
  'iw' => 'תסמונת וויליאמס',
  'ja' => 'ウィリアムズ症候群',
  'jw' => 'sindrom williams',
  'ka' => 'williams სინდრომი',
  'km' => 'ជម្ងឺ Williams',
  'kn' => 'ವಿಲಿಯಮ್ಸ್ ಸಿಂಡ್ರೋಮ್',
  'ko' => '윌리엄스 증후군',
  'lo' => 'ໂຣກ Williams',
  'lt' => 'williams sindromas',
  'lv' => 'Williams sindroms',
  'mi' => 'Williams syndrome',
  'mk' => 'Вилијамс синдром',
  'mn' => 'Williams хам шинж',
  'mr' => 'विल्यम्स सिंड्रोम',
  'ms' => 'sindrom williams',
  'mt' => 'sindromu Williams',
  'ne' => 'Williams सिंड्रोम',
  'nl' => 'williams syndroom',
  'no' => 'Williams syndrom',
  'pa' => 'ਵਿਲੀਅਮਜ਼ ਸਿੰਡਰੋਮ',
  'pl' => 'zespół Williamsa',
  'pt' => 'síndrome de Williams',
  'ro' => 'sindromul williams',
  'ru' => 'синдромом Вильямса',
  'sk' => 'Williams syndróm',
  'sl' => 'williams sindrom',
  'so' => 'Williams syndrome',
  'sq' => 'sindromi williams',
  'sr' => 'Вилијамс синдром',
  'sv' => 'Williams syndrom',
  'sw' => 'syndrome williams',
  'ta' => 'வில்லியம்ஸ் சிண்ட்ரோம்',
  'te' => 'విలియమ్స్ సిండ్రోమ్',
  'th' => 'วิลเลียมส์ซินโดรม',
  'tl' => 'Williams sindrom',
  'tr' => 'williams sendromu',
  'uk' => 'синдромом Вільямса',
  'ur' => 'ولیمز سنڈروم',
  'vi' => 'hội chứng williams',
  'yi' => 'ווילליאַמס סינדראָום',
  'yo' => 'Williams dídùn',
  'zh-CN' => '威廉斯综合征',
  'zh-TW' => '威廉斯綜合徵',
  'zu' => 'Williams syndrome',
}

DEFAULT_SYNDROME_STR = SYNDROME_TRANSLATIONS['en']

IGNORE_URL_PREFIX = [
  'http://www.williams-syndrome.org.uk',
  'http://www.williams-syndrome.org',
]

COUNTRIES_WIKIPEDIA_URL = "http://en.wikipedia.org/wiki/List_of_countries_and_dependencies_and_their_capitals_in_native_languages"
LANGUAGES_WIKIPEDIA_URL = "http://en.wikipedia.org/wiki/List_of_ISO_639-1_codes"


# Example:
# [
#   {
#     :country => "Ukraїna",
#     :capital => "Kyїv",
#     :country_en => "Ukraine",
#     :capital_en => "Kyiv",
#     :lang => "Ukrainian",
#   },
#   ...
# ]
def fetch_countries()
  doc = Nokogiri::HTML(open(COUNTRIES_WIKIPEDIA_URL))

  rows = doc.xpath("//table[contains(@class, 'wikitable')]/tr")
  rows.collect do |row|
    result = { }

    [
      [ :country_en, 'td[1]/a[1]/text()' ],
      [ :capital_en, 'td[2]/a[1]/text()' ],
      [ :country,    'td[3]/b[1]/text()' ],
      [ :capital,    'td[4]/b[1]/text()' ],
      [ :lang,       'td[5]/a[1]/text()' ],
    ].each do |key, xpath|
      result[key] = row.at_xpath(xpath).to_s.strip
    end

    (result[:country] == "") ? nil : result
  end.compact
end

# Example:
# [
#   {
#     :iso_code => "uk",
#     :name => "українська мова",
#     :name_en => "Ukrainian",
#   },
#   ...
# ]
def fetch_languages()
  doc = Nokogiri::HTML(open(LANGUAGES_WIKIPEDIA_URL))

  rows = doc.xpath("//table[contains(@class, 'wikitable')]/tr")
  rows.collect do |row|
    result = { }

    [
      [ :name_en,  'td[3]/a[1]/text()' ],
      [ :name,     'td[4]/text()' ],
      [ :iso_code, 'td[5]/text()' ],
    ].each do |key, xpath|
      result[key] = row.at_xpath(xpath).to_s.strip
    end

    result[:name] = (result[:name].split(",").first || "").strip

    (result[:iso_code] == "") ? nil : result
  end.compact
end

def get_iso_code_for_lang(lang, wiki_languages)
  found = wiki_languages.find do |wiki_language|
    wiki_language[:name_en] == lang
  end

  found && found[:iso_code]
end

def ignore_url?(url)
  found = IGNORE_URL_PREFIX.find do |prefix|
    url.start_with?(prefix)
  end

  (found != nil)
end


#
# Countries
#

wiki_countries = fetch_countries()
if DEBUG
  puts "= Countries:"
  pp fetch_countries()
end

output_file = File.new("./output/_countries.html", "w")
output_file << <<-eos
<html>
<head>
  <meta charset="utf-8">
  <title>Countries from Wikipedia</title>
  <link href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
  <h1>#{wiki_countries.count} countries from wikipedia</h1>
  <p>
    From: <a href="#{COUNTRIES_WIKIPEDIA_URL}">#{CGI.escapeHTML(COUNTRIES_WIKIPEDIA_URL)}</a>
  </p>
  <table class="table table-striped table-condensed">
    <thead>
      <tr>
        <th>Country</th>
        <th>Country (local)</th>
        <th>Capital</th>
        <th>Capital (local)</th>
        <th>Lang</th>
      </tr>
    </thead>
    <tbody>
eos

wiki_countries.each do |wiki_country|
  output_file << <<-eos
    <tr>
      <td>#{wiki_country[:country_en]}</td>
      <td>#{wiki_country[:country]}</td>
      <td>#{wiki_country[:capital_en]}</td>
      <td>#{wiki_country[:capital]}</td>
      <td>#{wiki_country[:lang]}</td>
    </tr>
  eos
end

output_file << <<-eos
    </tbody>
  </table>
</body>
</html>
eos
output_file.close


#
# Languages
#

wiki_languages = fetch_languages()
if DEBUG
  puts "= Languages:"
  pp wiki_languages
end

output_file = File.new("./output/_languages.html", "w")
output_file << <<-eos
<html>
<head>
  <meta charset="utf-8">
  <title>Languages from Wikipedia</title>
  <link href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
  <h1>#{wiki_languages.count} languages from wikipedia</h1>
  <p>
    From: <a href="#{LANGUAGES_WIKIPEDIA_URL}">#{CGI.escapeHTML(LANGUAGES_WIKIPEDIA_URL)}</a>
  </p>
  <table class="table table-striped table-condensed">
    <thead>
      <tr>
        <th>Name</th>
        <th>Name (local)</th>
        <th>ISO code</th>
      </tr>
    </thead>
    <tbody>
eos

wiki_languages.each do |wiki_language|
  output_file << <<-eos
    <tr>
      <td>#{wiki_language[:name_en]}</td>
      <td>#{wiki_language[:name]}</td>
      <td>#{wiki_language[:iso_code]}</td>
    </tr>
  eos
end

output_file << <<-eos
    </tbody>
  </table>
</body>
</html>
eos
output_file.close


#
# Let's go
#

puts "= Searching for #{wiki_countries.count} countries"
puts

total_search_urls = 0
total_results = 0

wiki_countries.each_with_index do |wiki_country, country_index|
  iso_lang = get_iso_code_for_lang(wiki_country[:lang], wiki_languages)

  ws_str = (iso_lang && SYNDROME_TRANSLATIONS[iso_lang]) || DEFAULT_SYNDROME_STR

  search_vars = [ wiki_country[:country], wiki_country[:country_en], wiki_country[:capital], wiki_country[:capital_en] ].uniq.compact

  # Navigation
  nav_html = '<ul class="pagination">'

  prev_country = if country_index > 0
    nav_html += <<-eos
    <li><a href="./#{wiki_countries[country_index - 1][:country_en]}.html">&laquo;</a></li>
    eos
  else
    nav_html += <<-eos
    <li class="disabled"><a href="#">&laquo;</a></li>
    eos
  end

  next_country = if country_index < (wiki_countries.count - 1)
    nav_html += <<-eos
    <li><a href="./#{wiki_countries[country_index + 1][:country_en]}.html">&raquo;</a></li>
    eos
  else
    nav_html += <<-eos
    <li class="disabled"><a href="#">&raquo;</a></li>
    eos
  end

  nav_html += '</ul>'

  output_file = File.new("./output/#{wiki_country[:country_en]}.html", "w")

  output_file << <<-eos
<html>
<head>
  <meta charset="utf-8">
  <title>Williams Syndrome - #{wiki_country[:country_en]}</title>
  <link href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

  #{nav_html}

  <h1>#{wiki_country[:country_en]} / #{wiki_country[:capital_en]}</h1>
  <p>
    Search strings: <em>#{search_vars.join(", ")}</em>
  </p>
  eos

  search_urls = [ ]
  results = [ ]

  search_vars.map do |search_var|
    search_str = "#{ws_str} #{search_var}"

    url = "http://www.google.com/search?hl=#{iso_lang}&q=#{CGI.escape(search_str)}"

    search_urls << url
    total_search_urls += 1

    puts "#{wiki_country[:country_en]} => #{url}"

    doc = Nokogiri::HTML(open(url))

    doc_parts = doc.xpath("//h3[@class='r']")
    doc_parts.each do |doc_part|
      title = doc_part.text
      link = CGI::parse(URI(doc_part.at('a')[:href]).query)["q"].first
      desc = doc_part.at("./following::div").css('span.st').text

      next if link.nil? || ignore_url?(link)

      total_results += 1

      results << {
        :title => title,
        :desc => desc,
        :link => link,
      }
    end
  end

  results = results.uniq{ |result| result[:link] }

  output_file << <<-eos
  <ul>
  eos

  search_urls.each do |search_url|
    output_file << <<-eos
    <li><a href="#{search_url}">#{CGI.escapeHTML(search_url)}</a></li>
    eos
  end

  output_file << <<-eos
  </ul>
  <table class="table table-striped table-condensed">
    <thead>
      <tr>
        <th>Title</th>
        <th>Description</th>
        <th>Link</th>
      </tr>
    </thead>
    <tbody>
  eos

  results.each do |result|
    output_file << <<-eos
      <tr>
        <td>#{result[:title]}</td>
        <td>#{result[:desc]}</td>
        <td><a href="#{result[:link]}">#{result[:link][0,60]}...</a></td>
      </tr>
    eos
  end

  output_file << <<-eos
    </tbody>
  </table>

  #{nav_html}

</body>
</html>
  eos

  output_file.close
end

puts "#{total_search_urls} search requests done"
puts "#{total_results} results found"
