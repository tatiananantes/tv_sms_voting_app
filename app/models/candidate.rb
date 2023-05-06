class Candidate < ApplicationRecord
  belongs_to :campaign
  has_many :votes, foreign_key: :choice_id
end
