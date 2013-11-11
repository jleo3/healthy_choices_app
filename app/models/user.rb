class User < ActiveRecord::Base
  #each user includes many restaurants and meals, with each restaurant having many meals and each meal appearing in one restaurant
  has_many :restaurants
  has_many :meals

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
