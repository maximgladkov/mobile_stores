module MobileStores
  class BlackBerryWorld
    include MobileStore

    act_as_json_source

    private

    def self.apps_url(query = nil, count = nil, country)
      url = "http://appworld.blackberry.com/cas/producttype/apps/listtype/search_listing/category/0/search/#{ CGI::escape(query) }?page=1&model=Imagination%20GPU&countrycode=#{ country.alpha2 }&lang=#{ country.languages.first }"
      url = "#{ url }&pagesize=#{ count }" if count
      url
    end

    def self.app_url(id, country)
      "http://appworld.blackberry.com/cas/content/#{ id }?model=Imagination%20GPU&countrycode=#{ country.alpha2 }&lang=#{ country.languages.first }"
    end

    def self.process_app_json(json)
      self.parse_element_json(json)
    end

    def self.process_apps_json(json)
      self.parse_list_json(json)
    end

    def self.parse_element_json(json)
      App.new({ 
        application_id: json['id'],
        title: json['name'],
        creator_name: json['vendorName'],
        creator_id: json['vendorId'],
        version: (json['cdDTO']['releaseVersion'] rescue nil),
        rating: (json['rating'] == -1 ? nil : json['rating']),
        description: json['description'],
        category: json['categories'][0]['name'],
        icon_url: "http://appworld.blackberry.com/webstore/servedimages/#{ json['iconId'] }.png/?t=2",
        view_url: "http://appworld.blackberry.com/webstore/content/#{ json['id'] }",
        price: (json['cdDTO']['price'].to_d rescue 0),
        compatibility: json['cdDTO']['supportedDevices'],
        screenshot_urls: (json['screenShots'] || []).map{ |s| "http://appworld.blackberry.com/webstore/servedimages/#{ s }.png/?t=11" }
      })
    end

    def self.parse_list_json(json)
      json['ldata'].map do |app|
        App.new({
          :application_id => app['id'],
          :title => app['name'],
          :icon_url => "http://appworld.blackberry.com/webstore/servedimages/#{ app['iconId'] }.png/?t=2"
        })
      end
    end
  end
end