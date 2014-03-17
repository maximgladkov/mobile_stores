# encoding: utf-8

require "spec_helper"

module MobileStores
  describe "WindowsStore" do
    describe ".find" do
      it "should select single app by ID" do
        app = WindowsStore.new.find("angry-birds/9168c4f3-217b-4a29-b543-7513bb4ae2ed")
        app.should_not be_nil

        [:title, :application_id, :creator_name, :creator_id, :version, :rating, :description, :category, :icon_url, :view_url, :price, :compatibility, :screenshot_urls].each do |field|
          app.send(field).should_not be_nil
        end
      end

      it "should return correct information for single app by application id" do
        # find Angry birds app (https://play.google.com/store/apps/details?id=com.rovio.angrybirds)
        app = App.in(:windows_store).find("angry-birds/9168c4f3-217b-4a29-b543-7513bb4ae2ed")
        app.should_not be_nil
        app.title.should eq("Angry Birds")
        app.application_id.should eq("angry-birds/9168c4f3-217b-4a29-b543-7513bb4ae2ed")
        app.creator_name.should eq("Rovio Entertainment Ltd")
        app.creator_id.should eq("Rovio Entertainment Ltd")
        app.version.should match(/\d+\.\d+\.\d+\.\d+/)
        app.rating.to_i.should_not be_nil
        app.description.should match /^Use the unique powers of the Angry Birds/
        app.category.should eq("Games")
        app.icon_url.should eq("http://cdn.marketplaceimages.windowsphone.com/v8/images/5f34c7c6-63f6-4113-bfa0-5d3380601252?imageType=ws_icon_large")
        app.view_url.should eq("http://www.windowsphone.com/en-us/store/app/angry-birds/9168c4f3-217b-4a29-b543-7513bb4ae2ed")
        app.price.should eq(0.99)
        app.compatibility.should include("Windows Phone 8")
        app.screenshot_urls.should_not be_empty
      end

      it "should not raise error if app exists for specified store and country" do
        expect{ App.in(:windows_store).country(:ru).find!("женский-календарь/1475828d-8d46-e011-854c-00237de2db9e") }.not_to raise_error
      end

      it "should raise error if app doesn't exist for specified store and country" do
        expect{ App.in(:windows_store).country(:in).find!("женский-календарь") }.to raise_error
      end
    end

    describe ".search" do
      it "should select multiple apps by query" do
        apps = WindowsStore.new.search("angry")
        apps.should_not be_empty
        apps.first.title.should match /Angry Birds/
      end

      it "should respect small count argument" do
        apps = WindowsStore.new.search("angry", 3)
        apps.size.should eq(3)
      end

      it "should respect large count argument" do
        apps = WindowsStore.new.search("angry", 200)
        apps.size.should eq(200)
      end
    end
  end
end