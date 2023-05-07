require_relative 'import_log_file'

votes_file = ARGV[0] || Rails.root.join('app', 'data', 'votes.txt')
ImportLogFile.import_votes_from_file(votes_file)
