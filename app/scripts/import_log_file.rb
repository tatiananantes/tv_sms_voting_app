require 'time'

module ImportLogFile
  extend self
 
  def import_votes(votes_file)

    puts "Processing..."

    File.foreach(votes_file) do |line|
      begin
        fields = line.chomp.split(/\s+/)
        next unless fields[0] == 'VOTE' # skip non-vote lines

        epoch = Integer(fields[1])
        campaign_name = fields[2].split(':', 2)[1]
        candidate_name = fields[4].split(':', 2)[1].capitalize
        validity = fields[3].split(':', 2)[1]

        campaign = Campaign.find_or_create_by(name: campaign_name)
        candidate = candidate_name.present? ? campaign.candidates.find_or_create_by(name: candidate_name) : nil
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

end