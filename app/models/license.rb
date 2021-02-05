class License < ApplicationRecord
  belongs_to :game

  validates :key, presence: true, uniqueness: { case_sensitive: false, scope: :platform }
  validates :platform, presence: true
  validates :status, presence: true

  enum platform: { game_on: 1 } 
  enum status: { available: 1, in_use: 2, inactive: 3 }
end
