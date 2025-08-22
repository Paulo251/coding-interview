class Tweet < ApplicationRecord
  belongs_to :user

  validates :body, presence: true, length: { maximum: 280 }

  scope :recent, -> { order(created_at: :desc) }
  scope :by_user, ->(user_id) { where(user_id: user_id) if user_id.present? }

  def self.next_cursor(tweets)
    tweets.last&.created_at&.to_i
  end

  def self.has_more?(tweets, limit = 20)
    tweets.size == limit
  end
end
