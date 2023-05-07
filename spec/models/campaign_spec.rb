require 'rails_helper'

RSpec.describe Campaign, type: :model do
  describe "associations" do
    it { should have_many(:votes) }
    it { should have_many(:candidates) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  context "campaign metrics" do
    let!(:campaign) { Campaign.create(name: "Test Campaign") }
    let!(:candidate1) { Candidate.create(name: "Candidate 1", campaign: campaign) }
    let!(:candidate2) { Candidate.create(name: "Candidate 2", campaign: campaign) }
    let!(:vote1) { Vote.create(validity: "during", campaign: campaign, candidate: candidate1) }
    let!(:vote2) { Vote.create(validity: "pre", campaign: campaign, candidate: candidate2) }
    let!(:vote3) { Vote.create(validity: "post", campaign: campaign, candidate: candidate1) }
    let!(:vote4) { Vote.create(validity: "during", campaign: campaign, candidate: candidate2) }
    let!(:vote5) { Vote.create(validity: "during", campaign: campaign, candidate: nil) }

    describe "#valid_votes" do
      it "returns the number of valid votes during the campaign" do
        expect(campaign.valid_votes).to eq(2)
      end
    end

    describe "#non_valid_votes" do
      it "returns the number of non-valid votes before and after the campaign" do
        expect(campaign.non_valid_votes).to eq(2)
      end
    end

    describe "#count_errors" do
      it "returns the number of votes with an empty or nil candidate" do
        expect(campaign.count_errors).to eq(1)
      end
    end
  end
end

