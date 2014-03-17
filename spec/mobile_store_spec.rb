require "spec_helper"

module MobileStores
  describe "MobileStore" do
    describe ".initialize" do
      it "should select United States as default country" do
        App.in(:app_store).country.alpha2.should eq('US')
      end
    end

    describe ".country" do
      it "should return MobileStore object with country selected" do
        App.in(:app_store).country(:in).country.name.should eq('India')
      end
    end

    describe ".find" do 
      it "should raise error if store is not specified" do 
        expect{ App.find("unknown id") }.to raise_error(NoMethodError)
      end

      it "should return nil if app was not found" do
        App.in(:app_store).find("unknown id").should be_nil
      end
    end

    describe ".find!" do 
      it "should raise error if store is not specified" do 
        expect{ App.find!("unknown id") }.to raise_error(NoMethodError)
      end

      it "should raise error if app was not found" do
        expect{ App.in(:app_store).find!("unknown id") }.to raise_error
      end
    end

    describe ".exists?" do
      it "should return true if app exists for specified store and country" do
        App.in(:app_store).exists?("343200656").should be_true
      end

      it "should return false if app doesn't exist for specified store and country" do
        App.in(:app_store).exists?("unknown id").should be_false
      end
    end

    describe "#find_app" do
      it "should return single app by application id" do
        # find Angry birds app (https://itunes.apple.com/us/app/angry-birds/id343200656)
        app = AppStore.find_app("343200656", Country.new('US'))
        app.should_not be_nil
        app.title.should eq("Angry Birds")
      end
    end
  end
end