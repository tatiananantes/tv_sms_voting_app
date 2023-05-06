class Candidate < ApplicationRecord
 belongs_to :campaign
 has_many :votes, foreign_key: :candidate_id
 validates :name, uniqueness: { scope: :campaign_id }
end
