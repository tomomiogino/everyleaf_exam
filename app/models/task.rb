class Task < ApplicationRecord
  with_options presence: true do
    validates :title, length: { maximum: 100 }
    validates :content, length: { maximum: 300 }
    validates :deadline
  end
  validate :date_not_before_now

  def date_not_before_now
    errors.add(:deadline, I18n.t('errors.messages.invalid_date')) if deadline.nil? || deadline < DateTime.current
  end
end
