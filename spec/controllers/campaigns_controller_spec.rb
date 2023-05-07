require 'rails_helper'

RSpec.describe CampaignsController, type: :controller do
  render_views
  
  describe 'GET index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'should render the campaign on the list' do
      campaign = Campaign.create(name: "Test Campaign")
      candidate = Candidate.create(name: "Candidate 1", campaign_id: campaign.id)
      vote = Vote.create(campaign: campaign, validity: 'during', candidate: candidate)
    
      get :index
     
      campaigns = controller.instance_variable_get('@campaigns')
  
      expect(campaigns).to include(campaign)
      expect(response.body).to include("Test Campaign")
    end
  end

  describe "GET #show" do
    it "displays the campaign name in the view" do
      campaign = Campaign.create(name: "Test Campaign")
      get :show, params: { id: campaign.id }
      expect(response.body).to include(campaign.name)
    end
    
    it "displays the candidates associated with the campaign" do
      campaign = Campaign.create(name: "Test Campaign")
      candidate1 = Candidate.create(name: "Candidate 1", campaign_id: campaign.id)
      candidate2 = Candidate.create(name: "Candidate 2", campaign_id: campaign.id)
      get :show, params: { id: campaign.id }
      expect(response.body).to include(candidate1.name)
      expect(response.body).to include(candidate2.name)
    end
  end
end
