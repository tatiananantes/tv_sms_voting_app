require 'rails_helper'

RSpec.describe Candidate, type: :model do
  let!(:campaign) { Campaign.create(name: "Test Campaign") }
  let!(:candidate1) { Candidate.create(name: "Candidate 1", campaign: campaign) }
  let!(:candidate2) { Candidate.create(name: "Candidate 2", campaign: campaign) }

  describe "associations" do
    it { should belong_to(:campaign) }
    it { should have_many(:votes) }
  end

  describe "validations" do
    it { should validate_uniqueness_of(:name).scoped_to(:campaign_id) }
  end

  describe "#score" do
    it "returns the number of valid votes for the candidate" do
      Vote.create(campaign: campaign, candidate: candidate1, validity: "during")
      
      expect(candidate1.score).to eq(1)
      expect(candidate2.score).to eq(0)
    end
  end
end


