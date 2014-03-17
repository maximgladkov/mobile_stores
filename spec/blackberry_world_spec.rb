require "spec_helper"

module MobileStores
  describe "BlackBerryWorld" do
    describe ".find" do
      it "should select single app by ID" do
        app = BlackBerryWorld.new.find("21717683")
        app.should_not be_nil

        [:title, :application_id, :creator_name, :creator_id, :version, :rating, :description, :category, :icon_url, :view_url, :price, :compatibility, :screenshot_urls].each do |field|
          app.send(field).should_not be_nil
        end
      end

      it "should return correct information for single app by application id" do
        # find Angry birds app (https://play.google.com/store/apps/details?id=com.rovio.angrybirds)
        app = App.in(:blackberry_world).find("85455")
        app.should_not be_nil
        app.title.should eq("Viber")
        app.application_id.should eq(85455)
        app.creator_name.should eq("Viber Media Inc")
        app.creator_id.should eq(20886)
        app.version.should match(/\d+\.\d+\.\d+/)
        app.rating.should be_nil
        app.description.should match /^Send free messages and make free calls/
        app.category.should eq("Social Networking")
        app.icon_url.should eq("http://appworld.blackberry.com/webstore/servedimages/2506685.png/?t=2")
        app.view_url.should eq("http://appworld.blackberry.com/webstore/content/85455")
        app.price.should eq(0)
        app.compatibility.should include("8100")
        app.screenshot_urls.should include("http://appworld.blackberry.com/webstore/servedimages/18254169.png/?t=11")
      end
    end

    describe ".search" do
      it "should select multiple apps by query" do
        apps = BlackBerryWorld.new.search("viber")
        apps.should_not be_empty
        apps.first.title.should match /Viber/
      end

      it "should respect small count argument" do
        apps = BlackBerryWorld.new.search("game", 3)
        apps.size.should eq(3)
      end

      it "should respect large count argument" do
        apps = BlackBerryWorld.new.search("game", 200)
        apps.size.should eq(200)
      end
    end
  end
end