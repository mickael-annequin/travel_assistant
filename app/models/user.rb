class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :trips, dependent: :destroy

  def initials
    name = username.presence || email.split("@").first
    name.split(/[\s._-]+/).first(2).map { |word| word[0] }.join.upcase
  end
end
