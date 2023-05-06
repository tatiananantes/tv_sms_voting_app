class Campaign < ApplicationRecord
  has_many :votes
  has_many :candidates
  validates :name, presence: true, uniqueness: true
end
