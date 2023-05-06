class Vote < ApplicationRecord
  belongs_to :campaign
  belongs_to :choice, class_name: "Candidate"
end
