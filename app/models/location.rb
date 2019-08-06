class Location < ApplicationRecord
  extend FriendlyId
  friendly_id :full_address, use: :slugged
  belongs_to :user
  has_many :encounters
  validate :unique_address, :required_fields, :address_exists
  geocoded_by :full_address do |object, results|
    if results.present?
     object.latitude = results.first.latitude
     object.longitude = results.first.longitude
    else
     object.latitude = nil
     object.longitude = nil
    end
  end
  before_validation :geocode
  def full_address
    addressArray = [address, city, state, country]
    addressArray.shift if address == ""
    addressArray.compact.join(", ")
  end
  def safe_title
    if title == "Untitled" || title != ""
      if address == ""
        return city
      else
        return address
      end
    else
      return title
    end
  end
  def unique_address
    Location.all.each do |l|
      errors.add(:address, "This location already exists") if l.full_address == full_address && l.id != id
    end
  end
  def required_fields
    if city == ""
      errors.add(:city, "You must enter in a city.")
    elsif state == ""
      errors.add(:state, "You cannot leave the state blank.")
    elsif country == ""
      errors.add(:country, "You cannot leave the country blank.")
    end
  end
  def address_exists
    errors.add(:address, "This location does not exist.") if latitude == nil
  end
  def self.state str
    geo = Geocoder.search(str).first
    { latitude: geo.latitude, longitude: geo.longitude }
  end
end
