class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :locations
  has_many :encounters
  has_many :species
  validates :display, presence: true
  validates :display, uniqueness: true, if: -> { self.display.present? }
  def isMine obj
    obj.user_id == id
  end
end
