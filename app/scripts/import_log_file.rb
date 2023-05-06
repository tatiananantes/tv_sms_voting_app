require 'time'

puts "Processing..."

File.foreach(Rails.root.join('app', 'data', 'votes.txt')) do |line|
  begin
    fields = line.chomp.split(/\s+/)
    next unless fields[0] == 'VOTE' # skip non-vote lines

    epoch = Integer(fields[1])
    campaign_name = fields[2].split(':', 2)[1]
    candidate_name = fields[4].split(':', 2)[1].capitalize
    validity = fields[3].split(':', 2)[1]

    campaign = Campaign.find_or_create_by(name: campaign_name)
    candidate = campaign.candidates.find_or_create_by(name: candidate_name)
    Vote.create(epoch: epoch, campaign: campaign, candidate: candidate, validity: validity)
  rescue StandardError => e
    puts "Error processing line: #{line.strip}\n#{e.message}"
    puts e.backtrace.inspect
  end
end

puts "Done!"
