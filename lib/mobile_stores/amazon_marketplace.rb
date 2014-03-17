module MobileStores
  class AmazonMarketplace
    include MobileStore

    act_as_html_source

    private

    def self.apps_url(query = nil, count = nil, country = nil)
      url = "http://www.amazon.com/s/?url=search-alias%3Dmobile-apps&"
      url = "#{ url }&field-keywords=#{ CGI::escape(query) }&keywords=#{ query }" if query
      url
    end

    def self.app_url(id, country)
      "http://www.amazon.com/gp/product/#{ id }"
    end

    def self.doc(url)
      Nokogiri::HTML(open(url, "User-Agent" => "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"))
    end

    def self.process_app_html(doc)
      self.parse_html_page(doc)
    end

    def self.process_apps_html(doc, count = nil)
      self.parse_html_list(doc, count)
    end

    def self.parse_html_page(doc)
      App.new({
        application_id: doc.css('input[name="ASIN.0"]')[0]['value'],
        title: doc.css('#btAsinTitle')[0].inner_text,
        creator_name: doc.css('.buying span a')[0].inner_text,
        creator_id: doc.css('.buying span a')[0].inner_text,
        version: doc.css(".bucket .content strong:contains('Version:')").first.next.inner_text.strip,
        rating: doc.css('.crAvgStars .swSprite')[0]['title'].match(/[0-9\.]/)[0].to_f,
        description: doc.css(".bucket div.h2:contains('Product Description')")[0].next.css('.aplus').inner_html.gsub(%r{</?[^>]+?>}, ''),
        category: doc.css(".bucket h2:contains('Look for Similar Items by Category') + div a")[1].inner_text,
        icon_url: doc.css('#original_image img')[0]['src'].gsub(/SL[0-9]+/, 'SL512').gsub(/AA[0-9]+/, 'AA512'),
        view_url: "http://www.amazon.com/gp/product/#{ doc.css('input[name="ASIN.0"]')[0]['value'] }",
        price: doc.css('.priceLarge')[0].inner_text.gsub(/[^0-9.,]+/,'').to_d,
        compatibility: doc.css(".bucket .content strong:contains('Minimum Operating System:')")[0].next.inner_text.strip,
        screenshot_urls: doc.css('.productThumbnail img')[1..-1].map{ |d| d['src'].gsub(/SL[0-9]+/, 'SL1024').gsub(/AA[0-9]+/, 'AA1024') }
      })
    end

    def self.parse_html_list(doc, count = nil, page = 1)
      apps = doc.css('.product').map do |app|
        App.new({
          :application_id => app['name'],
          :title => app.css('.productTitle a')[0].inner_text,
          :icon_url => app.css('.productImage img')[0]['src']
        })
      end

      if count and apps.size < count
        while apps.size < count and doc.css('#pagnNextLink').length > 0
          page += 1
          doc = self.doc("http://www.amazon.com#{ doc.css('#pagnNextLink')[0]['href'].gsub('http://www.amazon.com', '') }")
          apps += self.parse_html_list(doc)
        end
      end

      count ? apps.take(count) : apps
    end

  end
end