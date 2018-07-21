class User < ApplicationRecord
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :locations
  has_many :encounters
  has_many :species
  validates :display, presence: true
  validates :display, uniqueness: true, if: -> { self.display.present? }
  def is_mine obj
    obj.user_id == id
  end
  def self.authenticate_via_token email, token
    user = User.where("email = '#{email}'").first
    user.authentication_token == token
  end
end
