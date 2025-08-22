
class ReportGenerationJob < ApplicationJob
  queue_as :default

  def perform(report_type, email = nil)
    case report_type
    when 'users_tweets'
      generate_users_tweets_report(email)
    when 'companies_stats'
      generate_companies_report(email)
    else
      raise ArgumentError, "Unknown report type: #{report_type}"
    end
  end

  private

  def generate_users_tweets_report(email)
    data = generate_users_tweets_data
    send_report_email(email, 'Relatório de Usuários e Tweets', data) if email
    data
  end

  def generate_companies_report(email)
    data = generate_companies_data
    send_report_email(email, 'Relatório de Empresas', data) if email
    data
  end

  def generate_users_tweets_data
    User.order(:created_at)
        .includes(:tweets)
        .map do |user|
      {
        user_id: user.id,
        username: user.username,
        email: user.email,
        company: user.company.name,
        tweet_count: user.tweets.count,
        last_tweet_at: user.tweets.maximum(:created_at),
        tweets: user.tweets.order(created_at: :desc).limit(5).pluck(:body, :created_at)
      }
    end
  end

  def generate_companies_data
    Company.left_joins(:users)
           .select('companies.*, COUNT(users.id) as users_count')
           .group('companies.id')
           .order('users_count DESC')
           .map do |company|
      {
        company_id: company.id,
        company_name: company.name,
        users_count: company.users_count,
        website: company.website
      }
    end
  end

  def send_report_email(email, subject, data)
    ReportMailer.report_email(email, subject, data).deliver_later
  end
end
