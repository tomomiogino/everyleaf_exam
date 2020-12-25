class User < ApplicationRecord
  with_options presence: true do
    validates :name, length: { maximum: 50 }
    validates :email, length: { maximum: 255 }, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: true
    validates :password, length: {minimum: 6}, on: :create
  end
  before_validation {email.downcase!}
  has_secure_password
  has_many :tasks, dependent: :destroy

  after_update :last_admin_user_update?
  before_destroy :last_admin_user_destroy?

  def last_admin_user_update?
    if User.where(admin: true).count < 1
      errors.add(:admin, I18n.t('errors.messages.last_admin_user'))
      raise ActiveRecord::Rollback
    end
  end

  def last_admin_user_destroy?
    throw(:abort) if User.where(admin: true).count == 1 && self.admin
    errors.add(:admin, I18n.t('errors.messages.last_admin_user'))
  end
end
