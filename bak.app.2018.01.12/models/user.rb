class User < ApplicationRecord
  has_many :messages
  has_many :window_requests
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  def User.isadmin?
      return false if current_user.id != 1
  end
end
