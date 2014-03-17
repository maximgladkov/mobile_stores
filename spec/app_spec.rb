require "spec_helper"

module MobileStores
  describe "App" do
    describe "#in" do
      it "should accept symbol as argument" do
        stores = { 
          app_store: AppStore, 
          google_play: GooglePlay, 
          windows_store: WindowsStore, 
          blackberry_world: BlackBerryWorld, 
          amazon_marketplace: AmazonMarketplace 
        }

        stores.each_pair do |store, klass|
          App.in(store).should be_a klass 
        end
      end

      it "should accept string as argument" do
        stores = [AppStore, GooglePlay, WindowsStore, BlackBerryWorld, AmazonMarketplace]

        stores.each do |store|
          App.in(store.to_s).should be_a store 
        end
      end

      it "should raise not found error for unknown store" do
        expect{ App.in("UnknownStore") }.to raise_error
        expect{ App.in(:unknown_store) }.to raise_error
      end
    end

    describe "#app_store" do
      it "should return AppStore class" do
        App.app_store.should be_an AppStore
      end
    end

    describe "#google_play" do
      it "should return GooglePlay class" do
        App.google_play.should be_a GooglePlay
      end
    end

    describe "#windows_store" do
      it "should return WindowsStore class" do
        App.windows_store.should be_a WindowsStore
      end
    end

    describe "#blackberry_world" do
      it "should return BlackBerryWorld class" do
        App.blackberry_world.should be_a BlackBerryWorld
      end
    end

    describe "#amazon_marketplace" do
      it "should return AmazonMarketplace class" do
        App.amazon_marketplace.should be_a AmazonMarketplace
      end
    end
  end
end