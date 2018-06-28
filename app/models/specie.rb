class Specie < ApplicationRecord
  validate :unique_specie, :required_fields
  def unique_specie
    Specie.all.each do |s|
      errors.add(:common, "This specie is already in our system.") if s.common == common || s.scientific == scientific
    end
  end
  def required_fields
    if common == ""
      errors.add(:common, "You must provide a common name.")
    elsif scientific == ""
      errors.add(:scientific, "You must provide a scientific name.")
    end
  end
end
