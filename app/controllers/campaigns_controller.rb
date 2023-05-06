class CampaignsController < ApplicationController
  
  def index
    @campaigns = Campaign.joins(:votes).distinct
  end

  def show
    @campaign = Campaign.find(params[:id])
    @candidates = @campaign.candidates
  end

end
