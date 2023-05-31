require 'time'

module ImportLogFile
  extend self
 
  def import_votes(votes_file)

    puts "Processing..."

    cache = {:campaign =>{}, :candidate=>{}}

    File.foreach(votes_file) do |line|
      begin
        fields = line.chomp.split(/\s+/)
        next unless fields[0] == 'VOTE' # skip non-vote lines

        epoch = Integer(fields[1])
        campaign_name = fields[2].split(':', 2)[1]
        candidate_name = fields[4].split(':', 2)[1].capitalize
        validity = fields[3].split(':', 2)[1]

        campaign = find_or_create_campaign(campaign_name, cache)
        candidate = find_or_create_candidate(candidate_name, campaign, cache)
        Vote.create(epoch: epoch, campaign: campaign, candidate: candidate, validity: validity)
      rescue StandardError => e
        puts "Error processing line: #{line.strip}\n#{e.message}"
      end
    end

    puts "Done!"
  end

  def import_votes_from_file(file_path = nil)
    votes_file = file_path || Rails.root.join('app', 'data', 'votes.txt')
    import_votes(votes_file)
  end

  private

  def find_or_create_campaign(campaign_name, cache)
    begin
      cache[:campaign][campaign_name] ||= Campaign.find_or_create_by(name: campaign_name)
    rescue 
      cache[:campaign][campaign_name] ||= Campaign.find_by(name: campaign_name)
    end
    
  end

  def find_or_create_candidate(candidate_name, campaign, cache)
    return nil if candidate_name == ""
    # cache[:candidate]||= {}
    cache[:candidate][[campaign.id, candidate_name]] ||= campaign.candidates.find_or_create_by(name: candidate_name)
  end
end