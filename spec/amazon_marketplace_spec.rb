require "spec_helper"

module MobileStores
  describe "AmazonMarketplace" do
    describe ".find" do
      it "should select single app by ID" do
        app = AmazonMarketplace.new.find("B004SBQGHS")
        app.should_not be_nil

        [:title, :application_id, :creator_name, :creator_id, :version, :rating, :description, :category, :icon_url, :view_url, :price, :compatibility, :screenshot_urls].each do |field|
          app.send(field).should_not be_nil
        end
      end

      it "should return correct information for single app by application id" do
        # find Angry birds app (http://www.amazon.com/gp/product/B004SBQGHS)
        app = App.in(:amazon_marketplace).find("B004SBQGHS")
        app.should_not be_nil
        app.title.should eq("Angry Birds (Ad-Free)")
        app.application_id.should eq("B004SBQGHS")
        app.creator_name.should eq("Rovio Entertainment Ltd.")
        app.creator_id.should eq("Rovio Entertainment Ltd.")
        app.version.should match(/\d+\.\d+\.\d+/)
        app.rating.to_i.should eq(4)
        app.description.should match /^It's Birds vs. Pigs!/
        app.category.should eq("Games")
        app.icon_url.should eq("http://ecx.images-amazon.com/images/I/61bZ2vhn4kL._SL512_AA512_.png")
        app.view_url.should eq("http://www.amazon.com/gp/product/B004SBQGHS")
        app.price.should eq(0.99)
        app.compatibility.should eq("Android 2.3")
        app.screenshot_urls.should include("http://ecx.images-amazon.com/images/I/71DxlUnAJ0L._SL1024_AA1024_.jpg")
      end
    end

    describe ".search" do
      it "should select multiple apps by query" do
        apps = AmazonMarketplace.new.search("angry")
        apps.should_not be_empty
        apps.first.title.should match /Angry Birds/
      end

      it "should respect small count argument" do
        apps = AmazonMarketplace.new.search("angry", 3)
        apps.size.should eq(3)
      end

      it "should respect large count argument" do
        apps = AmazonMarketplace.new.search("angry", 200)
        apps.size.should eq(200)
      end
    end
  end
end