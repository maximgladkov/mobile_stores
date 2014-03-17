module MobileStores
  class WindowsStore
    include MobileStore

    COUNTRY_LANGUAGE = { :ao => 'pt', :ar => 'es', :am => 'en', :au => 'en', :la => 'az', :az => 'tn', :bd => 'en', :be => 'nl', :be => 'fr', :bj => 'fr', :bo => 'es', :br => 'pt', :bf => 'fr', :bi => 'fr', :cm => 'en', :ca => 'en', :ca => 'fr', :cz => 'cs', :cl => 'es', :co => 'es', :cd => 'fr', :cr => 'es', :ci => 'fr', :dk => 'da', :de => 'de', :ec => 'es', :ee => 'et', :sv => 'es', :es => 'es', :es => 'ca', :fr => 'fr', :gh => 'en', :gt => 'es', :gn => 'fr', :ht => 'fr', :hn => 'es', :hk => 'en', :hr => 'hr', :is => 'is', :in => 'en', :id => 'id', :ie => 'en', :it => 'it', :ke => 'en', :kw => 'en', :lv => 'lv', :li => 'de', :lt => 'lt', :mg => 'fr', :hu => 'hu', :mw => 'en', :my => 'ms', :my => 'en', :ml => 'fr', :mx => 'es', :mz => 'pt', :nl => 'nl', :nz => 'en', :ni => 'es', :ne => 'fr', :ng => 'en', :no => 'nb', :at => 'de', :la => 'uz', :uz => 'tn', :pk => 'en', :py => 'es', :pe => 'es', :ph => 'en', :ph => 'il', :pl => 'pl', :pt => 'pt', :do => 'es', :ro => 'ro', :rw => 'fr', :ch => 'de', :sn => 'fr', :al => 'sq', :sl => 'en', :sg => 'en', :si => 'sl', :sk => 'sk', :so => 'en', :za => 'en', :la => 'sr', :cs => 'tn', :ch => 'fr', :fi => 'fi', :se => 'sv', :ch => 'it', :tz => 'en', :td => 'fr', :tg => 'fr', :tr => 'tr', :ug => 'en', :gb => 'en', :us => 'en', :ve => 'es', :vn => 'vi', :zm => 'en', :zw => 'en', :gr => 'el', :by => 'be', :bg => 'bg', :kz => 'kk', :mk => 'mk', :ru => 'ru', :tj => 'ru', :tm => 'ru', :ua => 'uk', :il => 'he', :jo => 'ar', :ae => 'ar', :bh => 'ar', :dz => 'ar', :iq => 'ar', :kw => 'ar', :ma => 'ar', :sa => 'ar', :ye => 'ar', :tn => 'ar', :om => 'ar', :qa => 'ar', :eg => 'ar', :in => 'hi', :th => 'th', :kr => 'ko', :cn => 'zh', :tw => 'zh', :jp => 'ja', :hk => 'zh' 
    }

    act_as_html_source

    private

    def self.apps_url(query = nil, count = nil, country)
      url = "http://www.windowsphone.com/#{ COUNTRY_LANGUAGE[country.alpha2.downcase.to_sym] }-#{ country.alpha2.downcase }/store/search"
      url = "#{ url }?q=#{ CGI::escape(query) }" if query
      URI.encode url
    end

    def self.app_url(id, country)
      URI.encode "http://www.windowsphone.com/#{ country.languages.first }-#{ country.alpha2.downcase }/store/app/#{ id }"
    end

    def self.process_app_html(doc)
      app = self.parse_html_page(doc)
      raise "App not found." if app.nil?
      app
    end

    def self.process_apps_html(doc, count = nil)
      self.parse_html_list(doc, count)
    end

    def self.parse_html_page(doc)
      App.new({
        application_id: doc.css('[itemprop=url]')[0]['content'].match(/[^\/]+\/[^\/]+$/)[0],
        title: doc.css('[itemprop=name]')[0].inner_text,
        creator_name: doc.css('[itemprop=publisher]')[0].inner_text,
        creator_id: doc.css('[itemprop=publisher]')[0].inner_text,
        version: doc.css('[itemprop=softwareVersion]')[0].inner_text,
        rating: doc.css('[itemprop=ratingValue]')[0]['content'].to_f,
        description: doc.css('[itemprop=description]')[0].inner_text.gsub(%r{</?[^>]+?>}, ''),
        category: (doc.css('[itemprop=applicationCategory]')[0].inner_text.capitalize rescue nil),
        icon_url: doc.css('[itemprop=image]')[0]['src'],
        view_url: doc.css('[itemprop=url]')[0]['content'],
        price: doc.css('[itemprop=price]')[0].inner_text.gsub(/[^0-9.,]/, '').to_d,
        compatibility: doc.css('[itemprop=operatingSystems]').map{ |o| o.inner_text}.join(', '),
        screenshot_urls: doc.css('#screenshots a').map{ |d| d['href'] }
      })
    end

    def self.parse_html_list(doc, count = nil, page = 1)
      apps = doc.css('.appList td').map do |app|
        id_string = app.css('a')[0]['data-ov'].split(';').last
        App.new({
          :application_id => id_string.split(' ')[1] + '/' + id_string.split(' ')[0],
          :title => app.css('a')[1].inner_text,
          :icon_url => app.css('img')[0]['src']
        })
      end

      if count and page == 1
        while apps.size < count and doc.css('#nextLink').length > 0
          page += 1
          doc = Nokogiri::HTML(open("http://www.windowsphone.com#{ doc.css('#nextLink')[0]['href'] }"))
          apps += self.parse_html_list(doc)
        end
      end

      count ? apps.take(count) : apps
    end

  end
end