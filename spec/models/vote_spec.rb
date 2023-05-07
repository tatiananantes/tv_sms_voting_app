require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:campaign) }
    it { is_expected.to belong_to(:candidate).optional }
  end
end
