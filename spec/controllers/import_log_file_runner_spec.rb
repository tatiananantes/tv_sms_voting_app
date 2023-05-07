require 'rails_helper'
require 'stringio'

RSpec.describe 'Import Log File Runner' do
  it 'executes import_log_file_runner script' do
    # Create a sample data file
    votes_file = Rails.root.join('app', 'data', 'votes_runner_test.txt')
  
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

    # Run the import_log_file_runner script with the test data file
    ARGV[0] = votes_file.to_s
    load Rails.root.join('app', 'scripts', 'import_log_file_runner.rb')

    # Restore the original stdout
    $stdout = original_stdout

    # Add any assertions here to check the output or changes made by the script
    expect(output.string).to include("Processing...")
    expect(output.string).to include("Done!")
  end
end
