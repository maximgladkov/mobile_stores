module MobileStores
  class AppStore
    include MobileStore

    act_as_json_source

    private

    def self.apps_url(query = nil, count = nil, country = nil)
      url = "http://itunes.apple.com/search?media=software"
      url = "#{ url }&term=#{ CGI::escape(query) }" if query
      url = "#{ url }&limit=#{ count }" if count
      url = "#{ url }&country=#{ country.alpha2 }"
      url
    end

    def self.app_url(id, country)
      "http://itunes.apple.com/lookup?id=#{ CGI::escape(id) }&country=#{ country.alpha2 }"
    end

    def self.process_app_json(json)
      app = self.parse_json(json).first
      raise "App not found." if app.nil?
      app
    end

    def self.process_apps_json(json)
      self.parse_json(json)
    end

    def self.parse_json(json)
      if json['results']
        json['results'].map do |app|
          App.new({ 
            application_id: app['trackId'].to_s.force_encoding('utf-8'),
            title: app['trackName'].force_encoding('utf-8'),
            creator_name: app['artistName'].force_encoding('utf-8'),
            creator_id: app['artistId'].to_s.force_encoding('utf-8'),
            version: app['version'].to_s.force_encoding('utf-8'),
            rating: (app['averageUserRating'].to_f || 0).to_s.force_encoding('utf-8').to_f,
            description: app['description'].force_encoding('utf-8'),
            category: app['primaryGenreName'].force_encoding('utf-8'),
            icon_url: app['artworkUrl512'].force_encoding('utf-8'),
            view_url: app['trackViewUrl'].force_encoding('utf-8'),
            price: app['price'].to_s.force_encoding('utf-8').to_d,
            compatibility: app['supportedDevices'].sort,
            screenshot_urls: app['screenshotUrls'] + app['ipadScreenshotUrls']
          })
        end
      else
        []
      end
    end

  end
end