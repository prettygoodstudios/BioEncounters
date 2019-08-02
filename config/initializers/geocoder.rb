# config/initializers/geocoder.rb
Geocoder.configure(

  # street address geocoding service (default :google)
  lookup: :opencagedata,

  # IP address geocoding service (default :ipinfo_io)
  ip_lookup: :ipinfo_io,

  # to use an API key:
  api_key: ENV["GEOCODE_KEY"],

  # geocoding service request timeout, in seconds (default 3):
  timeout: 10,

  # set default units to kilometers:
  units: :km,

  # caching (see [below](#caching) for details):
  #cache: Redis.new,
  #cache_prefix: "..."

)
