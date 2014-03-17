require 'bigdecimal'
require 'bigdecimal/util'
require 'nokogiri'
require 'open-uri'
require 'countries'
require "mobile_stores/app"
require "mobile_stores/mobile_store"
require "mobile_stores/app_store"
require "mobile_stores/black_berry_world"
require "mobile_stores/google_play"
require "mobile_stores/windows_store"
require "mobile_stores/amazon_marketplace"

module MobileStores

  STORES = { 
    :app_store => AppStore, 
    :google_play => GooglePlay, 
    :windows_store => WindowsStore, 
    :blackberry_world => BlackBerryWorld, 
    :amazon_marketplace => AmazonMarketplace 
  }

end