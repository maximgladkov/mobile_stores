require "spec_helper"

module MobileStores
  describe "GooglePlay" do
    describe ".find" do
      it "should select single app by ID" do
        app = GooglePlay.new.find("com.rovio.angrybirds")
        app.should_not be_nil

        [:title, :application_id, :creator_name, :creator_id, :version, :rating, :description, :category, :icon_url, :view_url, :price, :compatibility, :screenshot_urls].each do |field|
          app.send(field).should_not be_nil
        end
      end

      it "should return correct information for single app by application id" do
        # find Angry birds app (https://play.google.com/store/apps/details?id=com.rovio.angrybirds)
        app = App.in(:google_play).find("com.rovio.angrybirds")
        app.should_not be_nil
        app.title.should eq("Angry Birds")
        app.application_id.should eq("com.rovio.angrybirds")
        app.creator_name.should eq("Rovio Mobile Ltd.")
        app.creator_id.should eq("Rovio Mobile Ltd.")
        app.version.should match(/\d+\.\d+\.\d+/)
        app.rating.to_i.should eq(4)
        app.description.should match /^The survival of the Angry Birds/
        app.category.should eq("Arcade & Action")
        app.icon_url.should eq("https://lh6.ggpht.com/M9q_Zs_CRt2rbA41nTMhrPqiBxhUEUN8Z1f_mn9m89_TiHbIbUF8hjnc_zwevvLsRIJy=w300")
        app.view_url.should eq("https://play.google.com/store/apps/details?hl=en&id=com.rovio.angrybirds")
        app.price.should eq(0)
        app.compatibility.should eq("2.3 and up")
        app.screenshot_urls.should include("https://lh3.ggpht.com/nt7lisvneE-S-W1SP8hjfLD-JVrX_cuWLJaT2eKKn4LmvpzscqwXS1vnl_GSN95JCm2P=h900")
      end
    end

    describe ".search" do
      it "should select multiple apps by query" do
        apps = GooglePlay.new.search("angry")
        apps.should_not be_empty
        apps.first.title.should match /Angry Birds/
      end

      it "should respect small count argument" do
        apps = GooglePlay.new.search("angry", 3)
        apps.size.should eq(3)
      end

      it "should respect large count argument" do
        apps = GooglePlay.new.search("angry", 200)
        apps.size.should eq(200)
      end
    end
  end
end