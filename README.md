# Mobile Stores

Mobile Stores gem is a tool to fetch information from most popular mobile application stores: App Store, Google Play, Amazon Marketplace, Blackberry World and Windows Store.

## Installation

Add this line to your application's Gemfile:

    gem 'mobile_stores'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mobile_stores

## Usage

### Find single app in the App Store:

    App.in(:app_store).find("12345") # returns nil if app is not found
    App.in(:app_store).find!("12345") # raises exceptions if app is not found

### Search Google Play for apps:

    App.in(:google_play).search("Angry Birds")
    App.in(:google_play).search("Angry Birds", 10) # limit number of apps returned

### Check if app exists in Blackberry World:

    App.in(:blackberry_world).exists?("12345")

### Specify country for searches:

    App.in(:app_store).country(:in).find("12345")
    App.in(:amazon_marketplace).country(:ru).search("Yandex")
    App.in(:windows_store).country(:de).exists?("12345")

### Get information from returned app:

    # find Angry birds app (https://itunes.apple.com/us/app/angry-birds/id343200656)
    app = App.in(:app_store).find("343200656")
    app.title # => "Angry Birds"
    app.application_id # => "343200656"
    app.creator_name # => "Rovio Entertainment Ltd"
    app.creator_id # => "298910979"
    app.version # => "1.0.0"
    app.rating # => 5.0
    app.description # => "Use the unique powers..."
    app.category # => "Games"
    app.icon_url # => "http://a1974.phobos.apple.com/us/..."
    app.view_url # => "https://itunes.apple.com/us/app/angry-birds/id343200656?mt=8&uo=4"
    app.price # => 0.99
    app.compatibility # => ["iPadWifi", "iPodTouchFifthGen", ...]
    app.screenshot_urls # => ["http://a5.mzstatic.com/us/...", ...]

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
