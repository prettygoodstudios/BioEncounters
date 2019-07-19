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
    Encounter.find_by_sql("SELECT e.description, e.date, e.id as id, e.id as encounter_id, l.id as location_id, l.latitude, l.longitude, l.city, l.state as state, l.address, l.title as title, l.country, s.common, s.id as specie_id FROM encounters e JOIN locations l ON e.location_id = l.id JOIN species s ON e.specie_id = s.id WHERE e.date BETWEEN '#{start}' AND '#{last}' ORDER BY e.date DESC")
  end
  def self.month_range start, last
    Encounter.find_by_sql("SELECT e.description, e.date, e.id as id, e.id as encounter_id, l.id as location_id, l.latitude, l.longitude, l.city, l.state as state, l.address, l.title as title, l.country, s.common, s.id as specie_id FROM encounters e JOIN locations l ON e.location_id = l.id JOIN species s ON e.specie_id = s.id WHERE date_part('month', date) BETWEEN date_part('month', timestamp '2001-#{start}-01 00:00:00') AND date_part('month', timestamp '2001-#{last}-30 24:00:00') ORDER BY e.date DESC")
  end
  def self.get_by_specie_and_month start, last, specie_id
    encounters = Encounter.month_range(start, last)
    encounters.select { |e| e.specie_id.to_i == specie_id.to_i }
  end
  def get_month
    month = date.month
    year = date.year
    first_day = Date.civil(year,month,1)
    last_day = Date.civil(year,month,-1)
    {start: first_day, end: last_day}
  end
  def self.get_time_graph type, id
    encounters = Encounter.find_by_sql("SELECT date_part('month', date) as month, COUNT(id) as encounter_count FROM encounters WHERE #{type === 'specie' ? 'specie_id='+id : 'location_id='+id} GROUP BY date_part('month', date) ORDER BY month ASC")
    months = []
    12.times do |i|
      ri =  encounters.rindex { |x| x.month.to_i == i }
      if ri
        m = encounters[ri]
        months.push({ :month => m.month.to_s.split(".")[0].to_i, :encounter_count => m.encounter_count})
      else
        months.push({ :month => i.to_i, :encounter_count => 0.to_i })
      end
    end
    puts months
  end
end
