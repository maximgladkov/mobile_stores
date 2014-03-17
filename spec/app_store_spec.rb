require "spec_helper"

module MobileStores
  describe "AppStore" do
    describe ".find" do
      it "should select single app by ID" do
        app = AppStore.new.find("343200656")
        app.should_not be_nil

        [:title, :application_id, :creator_name, :creator_id, :version, :rating, :description, :category, :icon_url, :view_url, :price, :compatibility, :screenshot_urls].each do |field|
          app.send(field).should_not be_nil
        end
      end

      it "should raise error if store is not specified" do 
        expect{ App.find("unknown id") }.to raise_error(NoMethodError)
      end

      it "should return correct information for single app by application id" do
        # find Angry birds app (https://itunes.apple.com/us/app/angry-birds/id343200656)
        app = App.in(:app_store).find("343200656")
        app.should_not be_nil
        app.title.should eq("Angry Birds")
        app.application_id.should eq("343200656")
        app.creator_name.should eq("Rovio Entertainment Ltd")
        app.creator_id.should eq("298910979")
        app.version.should match(/\d+\.\d+\.\d+/)
        app.rating.should eq(4.5)
        app.description.should match /^Use the unique powers/
        app.category.should eq("Games")
        app.icon_url.should eq("http://a1974.phobos.apple.com/us/r30/Purple/v4/fd/dc/91/fddc91e7-c6b2-2552-bf24-d0dce3ef72b6/mzl.onvampds.png")
        app.view_url.should eq("https://itunes.apple.com/us/app/angry-birds/id343200656?mt=8&uo=4")
        app.price.should eq(0.99)
        app.compatibility.should eq(["iPadWifi", "iPodTouchFifthGen", "iPadThirdGen4G", "iPadFourthGen", "iPad3G", "iPadMini", "iPhone4", "iPodTouchourthGen", "iPhone5c", "iPhone-3GS", "iPadFourthGen4G", "iPadMini4G", "iPad23G", "iPadThirdGen", "iPad2Wifi", "iPhone4S", "iPhone5", "iPodTouchThirdGen", "iPhone5s"].sort)
        app.screenshot_urls.should include("http://a5.mzstatic.com/us/r30/Purple/v4/9b/48/67/9b48678d-39e2-026f-7fdb-410cfdfa7a8d/screen1136x1136.jpeg")
      end

      it "should not raise error if app exists for specified store and country" do
        expect{ App.in(:app_store).country(:ru).find!("724254877") }.not_to raise_error
      end

      it "should raise error if app doesn't exist for specified store and country" do
        expect{ App.in(:app_store).country(:in).find!("724254877") }.to raise_error
      end
    end

    describe ".search" do
      it "should select multiple apps by query" do
        apps = AppStore.new.search("angry")
        apps.should_not be_empty
        apps.first.title.should match /Angry Birds/
      end

      it "should respect small count argument" do
        apps = AppStore.new.search("angry", 3)
        apps.size.should eq(3)
      end

      it "should respect large count argument" do
        apps = AppStore.new.search("angry", 200)
        apps.size.should eq(200)
      end
    end
  end
end