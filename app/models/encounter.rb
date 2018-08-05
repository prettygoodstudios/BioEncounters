class Encounter < ApplicationRecord
  belongs_to :location
  validate :required_fields
  def required_fields
    if description == ""
      errors.add(:description, "You must provide a description")
    elsif location_id == nil || Location.find(location_id) == nil
      errors.add(:location_id, "The encounter must be tied to a location.")
    elsif specie_id == nil || Specie.find(specie_id) == nil
      errors.add(:specie_id, "The encounter must be tied to a specie.")
    elsif date == nil
      errors.add(:date, "You must provide a valid date")
    end
  end
  def date_occurences
    Encounter.where("date = '#{date.to_s}'").length
  end
  def self.date_range start, last
    Encounter.find_by_sql("SELECT e.description, e.date, e.id as id, e.id as encounter_id, l.id as location_id, l.latitude, l.longitude, l.city, l.state as state, s.common, s.id as specie_id FROM encounters e JOIN locations l ON e.location_id = l.id JOIN species s ON e.specie_id = s.id WHERE e.date BETWEEN '#{start}' AND '#{last}'")
  end
  def self.month_range start, last
    Encounter.find_by_sql("SELECT e.description, e.date, e.id as id, e.id as encounter_id, l.id as location_id, l.latitude, l.longitude, l.city, l.state as state, s.common, s.id as specie_id FROM encounters e JOIN locations l ON e.location_id = l.id JOIN species s ON e.specie_id = s.id WHERE date_part('month', date) BETWEEN date_part('month', timestamp '2001-#{start}-16 20:38:40') AND date_part('month', timestamp '2001-#{last}-16 20:38:40')")
  end
  def get_month
    month = date.month
    year = date.year
    first_day = Date.civil(year,month,1)
    last_day = Date.civil(year,month,-1)
    {start: first_day, end: last_day}
  end
end
