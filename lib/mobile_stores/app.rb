module MobileStores
  class App

    attr_accessor :title, :application_id, :creator_name, :creator_id, :version, :rating, :description, :category, :icon_url, :view_url, :price, :compatibility, :screenshot_urls

    def initialize(hash = {})
      hash.each_pair do |key, value|
        self.send "#{ key }=", value
      end
    end

    class << self
      attr_accessor :store

      # Selects the store for further manipulations.
      #
      #   App.in(:app_store)
      #
      def in(store)
        store_class = if store.is_a? Symbol
          MobileStores::STORES[store]
        elsif store.is_a? String
          Object.const_get(store) rescue nil
        elsif store.is_a? Class
          store
        end

        raise NotImplementedError, "#{ store } is not implemented yet." if store.nil?

        store_class.new
      end

      # Selects Apple AppStore for further manipulations.
      def app_store
        self.in(AppStore)
      end

      # Selects Google Play Store for further manipulations.
      def google_play
        self.in(GooglePlay)
      end

      # Selects Windows Store for further manipulations.
      def windows_store
        self.in(WindowsStore)
      end

      # Selects BlackBerry World Store for further manipulations.
      def blackberry_world
        self.in(BlackBerryWorld)
      end

      # Selects BlackBerry World Store for further manipulations.
      def amazon_marketplace
        self.in(AmazonMarketplace)
      end
    end

  end
end