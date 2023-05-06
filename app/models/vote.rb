class Vote < ApplicationRecord
  belongs_to :campaign
  belongs_to :candidate, optional: true
end
