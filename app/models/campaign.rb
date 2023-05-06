class Campaign < ApplicationRecord
  has_many :votes
  has_many :candidates
  
  validates :name, presence: true, uniqueness: true

  def valid_votes
    votes.where(validity: "during").count
  end

  def non_valid_votes
    votes.where(validity: ['pre', 'post']).count
  end

  def count_errors
    votes.where(candidate: Candidate.where(name: '')).count
  end

end
