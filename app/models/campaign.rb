class Campaign < ApplicationRecord
  has_many :votes
  has_many :candidates
  
  validates :name, presence: true, uniqueness: true

  def valid_votes
    votes.joins(:campaign, :candidate)
         .where(validity: "during")
         .where.not(campaigns: { id: nil })
         .where.not(candidates: { id: nil })
         .count
  end
  

  def non_valid_votes
    votes.where(validity: ['pre', 'post']).count
  end

  def count_errors
    votes.where(candidate: [Candidate.where(name: ''), nil]).count
  end

end
