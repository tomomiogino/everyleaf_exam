class Task < ApplicationRecord
  with_options presence: true do
    validates :title, length: { maximum: 100 }
    validates :content, length: { maximum: 300 }
    validates :deadline
  end
  validate :date_not_before_now
  enum status: {waiting: 0, working: 1, completed: 2}

  def date_not_before_now
    errors.add(:deadline, I18n.t('errors.messages.invalid_date')) if deadline.nil? || deadline < DateTime.current
  end

  scope :serch_title, ->(title) {
    return if title.blank?
    where('title LIKE ?', "%#{title}%")
  }

  scope :serch_status, ->(status) {
    return if status.blank?
    where(status: status)
  }

  scope :serch, ->(search_task_params) {
    serch_title(search_task_params[:title]).
    serch_status(search_task_params[:status])
  }
end
