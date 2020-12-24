class User < ApplicationRecord
  with_options presence: true do
    validates :name, length: { maximum: 50 }
    validates :email, length: { maximum: 255 }, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: true
    validates :password, length: {minimum: 6}, on: :create
  end
  before_validation {email.downcase!}
  has_secure_password
  has_many :tasks
end
