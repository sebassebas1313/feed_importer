class Podcast < ApplicationRecord
  has_many :episodes, dependent: :destroy

  validates :feed_url, uniqueness: { case_sensitive: true }
end
