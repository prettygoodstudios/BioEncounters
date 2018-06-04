class Location < ApplicationRecord
  belongs_to :user
  has_many :encounters
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
    addressArray.compact.join(", ")
  end
end
