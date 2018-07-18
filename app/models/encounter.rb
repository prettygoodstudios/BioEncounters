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
  def date_occurences
    Encounter.where("date = '#{date.to_s}'").length
  end
  def self.date_range start, last
    Encounter.find_by_sql("SELECT e.description, e.id as encounter_id, l.id as location_id, l.latitude, l.longitude, l.city, s.common FROM encounters e JOIN locations l ON e.location_id = l.id JOIN species s ON e.specie_id = s.id WHERE e.date BETWEEN '#{start}' AND '#{last}'")
  end
end
