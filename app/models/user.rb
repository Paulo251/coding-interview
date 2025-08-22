class User < ApplicationRecord
  belongs_to :company
  has_many :tweets, dependent: :destroy
  after_create :send_welcome_email

  scope :by_company, ->(company_id) { where(company_id: company_id) if company_id.present? }
  scope :by_username, ->(username) { where("username ILIKE ?", "%#{username}%") if username.present? }


  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :display_name, presence: true


  after_create :send_welcome_email

  def tweet_count
    tweets.count
  end

  private

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_later
  end

end
