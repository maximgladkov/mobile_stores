require "json"
require "net/http"
require "uri"

module MobileStores
  module MobileStore

    module InstanceMethods

      attr_accessor :country

      def initialize
        # set country to United States as default
        @country = Country.new(:us)
        super
      end

      # Selects store corresponding to country or returns selected country,
      # if arguments is not specified
      #  
      #   App.in(:app_store).country(:us).find("12345") # returns +App+ object
      # 
      def country(country = nil)
        if country
          @country = Country.new(country)
          self
        else
          @country
        end
      end

      # Finds app in store by ID.
      # Returns nil if app was not found.
      #
      #   App.in(:app_store).find("12345") # returns +App+ object
      #
      def find(id)
        find!(id) rescue nil
      end

      # Finds app in store by ID.
      # Raises error if app was not found.
      #
      #   App.in(:app_store).find("12345") # returns +App+ object
      #
      def find!(id)
        self.class.find_app(id, country)
      end

      # Searches apps in store by query
      #
      #   App.in(:app_store).search("angry") # returns array of +App+ objects
      #
      def search(query, count = nil)
        self.class.search_apps(query, count, country)
      end

      # Returns true if app exists in store searching by ID, 
      # otherwise returns false
      def exists?(id)
        not find(id).nil?
      end

    end

    module ClassMethods

      def act_as_json_source
        self.extend(JsonClassMethods)
      end

      def act_as_html_source
        self.extend(HtmlClassMethods)
      end

      # Returns url for a list of apps.
      def apps_url(query = nil, count = nil)
        raise_not_implemented
      end

      # Returns url for a single app.
      def app_url(id)
        raise_not_implemented
      end

      private
      
      # Raises +NotImplementedError+ when called.
      def raise_not_implemented
        raise NotImplementedError, "#{ self.name.to_s }.#{ caller[0] =~ /`([^']*)'/ and $1 } is not implemented."
      end
    end

    module JsonClassMethods
      
      # Finds app in store by ID.
      #
      #   AppStore.find_app("12345") # returns +App+ object
      #
      def find_app(id, country)
        process_app_json(json(app_url(id, country)))
      end

      # Searches apps in store by query.
      #
      #   AppStore.search_apps("angry") # returns array of +App+ objects
      #
      def search_apps(query, count = nil, country)
        process_apps_json(json(apps_url(query, count, country)))
      end

      private

      # Processes json for a list of apps.
      def process_apps_json(json)
        raise_not_implemented
      end

      # Process json for a single app.
      def process_app_json(json)
        raise_not_implemented
      end

      # Fetches json object from url.
      def json(url)
        response = Net::HTTP.get_response(URI.parse(url))
        JSON.parse(response.body)
      end

    end

    module HtmlClassMethods
      
      # Finds app in store by ID.
      #
      #   AppStore.find_app("12345") # returns +App+ object
      #
      def find_app(id, country)
        process_app_html(doc(app_url(id, country)))
      end

      # Searches apps in store by query.
      #
      #   AppStore.search_apps("angry") # returns array of +App+ objects
      #
      def search_apps(query, count = nil, country)
        process_apps_html(doc(apps_url(query, count, country)), count)
      end

      private

      # Processes json for a list of apps.
      def process_apps_html(html, count)
        raise_not_implemented
      end

      # Process json for a single app.
      def process_app_html(html)
        raise_not_implemented
      end

      # Fetches json object from url.
      def doc(url)
        Nokogiri::HTML(open(url))
      end

    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    include InstanceMethods

  end
end