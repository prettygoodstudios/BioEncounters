class Encounter < ApplicationRecord
  belongs_to :location
  validate :required_fields
  def required_fields
    if description == ""
      errors.add(:description, "You must provide a description")
    elsif location_id == nil || @location.find(location_id) == nil
      errors.add(:location_id, "The encounter must be tied to a location.")
    elsif specie_id == nil || @specie.find(specie_id) == nil
      errors.add(:specie_id, "The encounter must be tied to a specie.")
    elsif date == nil
      errors.add(:date, "You must provide a valid date")
    end
  end
end
