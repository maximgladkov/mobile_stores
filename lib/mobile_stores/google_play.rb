# GooglePlay doesn't support country based filtering, so every country is
# supported by default
module MobileStores
  class GooglePlay
    include MobileStore

    act_as_html_source

    private

    def self.apps_url(query = nil, count = nil, country = nil)
      url = "https://play.google.com/store/search?hl=en"
      url = "#{ url }&q=#{ CGI::escape(query) }" if query
      url = "#{ url }&start=0&num=#{ count }" if count
      url
    end

    def self.app_url(id, country)
      "https://play.google.com/store/apps/details?id=#{ id }&hl=en"
    end

    def self.process_app_html(doc)
      self.parse_html_page(doc)
    end

    def self.process_apps_html(doc, count = nil)
      self.parse_html_list(doc, count)
    end

    def self.parse_html_page(doc)
      App.new({
        application_id: doc.css('.details-wrapper')[0]['data-docid'],
        title: doc.css('.document-title div')[0].inner_text.strip,
        creator_name: doc.css('.document-subtitle.primary')[0].inner_text.strip,
        creator_id: doc.css('.document-subtitle.primary')[0].inner_text.strip,
        version: doc.css('[itemprop=softwareVersion]')[0].inner_text.strip,
        rating: doc.css('[itemprop=ratingValue]')[0]['content'].to_f,
        description: doc.css('[itemprop=description] .app-orig-desc')[0].inner_text.strip.gsub(%r{</?[^>]+?>}, ''),
        category: doc.css('.document-subtitle.category')[0].inner_text.strip,
        icon_url: doc.css('.cover-image')[0]['src'],
        view_url: "https://play.google.com/store/apps/details?hl=en&id=#{ doc.css('.details-wrapper')[0]['data-docid'] }",
        price: doc.css('[itemprop=price]')[0]["content"].to_d,
        compatibility: (doc.css('.metadata div.content[itemprop=operatingSystems]')[0].inner_text.strip rescue nil),
        screenshot_urls: doc.css('.full-screenshot').map{ |d| d['src'] }
      })
    end

    def self.parse_html_list(doc, count = nil)
      apps = doc.css('.card-list .card').map do |app|
        App.new({
          :application_id => app['data-docid'],
          :title => app.css('img')[0]['alt'],
          :icon_url => app.css('img')[0]['src']
        })
      end

      count ? apps.take(count) : apps
    end

  end
end