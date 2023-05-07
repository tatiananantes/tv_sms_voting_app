require 'rails_helper'
require_relative '../../app/scripts/import_log_file'
require 'stringio'

RSpec.describe 'Import Log File' do

  it 'imports votes from file' do
  
    # Create a sample data file
    votes_file = Rails.root.join('app', 'data', 'votes_test.txt')
  
    File.open(votes_file, 'a') do |file|
      file.puts "VOTE 1234567890 Campaign:camp_1 Validity:before Choice:Joana\n"
      file.puts "VOTE 1234567891 Campaign:camp_1 Validity:during Choice:Rita\n"
      file.puts "VOTE 1234567899 Campaign:camp_1 Validity:during Choice:Rita\n"
      file.puts "VOTE 1234567878 Campaign:camp_2 Validity:during Choice:Pedro\n"
      file.puts "VOTE 1234567891 Campaign:camp_2 Validity:during\n"
    end

    output = StringIO.new
    original_stdout = $stdout
    $stdout = output

    ImportLogFile.import_votes_from_file(votes_file)

    $stdout = original_stdout

    expect(Campaign.pluck(:name)).to include("camp_1", "camp_2")
    expect(Vote.pluck(:validity)).to include("before", "during")
    expect(Vote.pluck(:validity)).to_not include("post")
    expect(Campaign.count).to eq(2)
    expect { ImportLogFile.import_votes(votes_file) }.to change { Campaign.where(name: 'camp_1').first.votes.count }.by(3)
    expect(Candidate.count).to eq(3)
    expect(output.string).to include('Error processing line: VOTE 1234567891 Campaign:camp_2 Validity:during')
  end
  
end
