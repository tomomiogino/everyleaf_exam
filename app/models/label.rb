class Label < ApplicationRecord
  belongs_to :user
  has_many :labelings, dependent: :destroy
  has_many :tasks, through: :labelings, source: :task

  validates :name, presence: true, length: { maximum: 30 }, uniqueness: true
end
