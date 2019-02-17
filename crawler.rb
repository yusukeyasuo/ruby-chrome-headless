# 参考: https://rooter.jp/web-crawling/setup-headless-chrome-mac/

require 'nokogiri'
require 'selenium-webdriver'
ua = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36"

# ブラウザ立ち上げモード
caps = Selenium::WebDriver::Remote::Capabilities.chrome('chromeOptions' => {args: ["--user-agent=#{ua}", 'window-size=1280x800']})
# ヘッドレスモード
# caps = Selenium::WebDriver::Remote::Capabilities.chrome('chromeOptions' => {args: ["--headless","--no-sandbox", "--disable-setuid-sandbox", "--disable-gpu", "--user-agent=#{ua}", 'window-size=1280x800']})
driver = Selenium::WebDriver.for :chrome, desired_capabilities: caps

#スクレイピングしたいサイト
driver.navigate.to "https://www.jnto.go.jp/emergency/jpn/mi_guide.html"
sleep 2

driver.find_element(:class, 'filter-areas').click
sleep 1

driver.find_element(:xpath, '//option[@value="a08_tokyo"]').click
sleep 1

driver.find_element(:id, 'searchBtn').click
sleep 5

#Nokogiriを用いてHTMLをパースする
doc = Nokogiri::HTML.parse(driver.page_source, nil, 'utf-8')
area = doc.at_xpath('//div[@id="searchArea"]')
nodes = area.xpath('//div[@class="element shuffle-item filtered"]')
puts '===>nodes count: '
puts nodes.count
nodes.each do |node|
  puts node.at_xpath('section/h1').inner_html
end
