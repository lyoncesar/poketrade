class Exchange < ApplicationRecord
  validates :avg_receiving, :avg_sending, :receiving, :sending, presence: true
end
