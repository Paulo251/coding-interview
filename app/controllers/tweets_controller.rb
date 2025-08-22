class TweetsController < ApplicationController

 def index
    if params[:user_id]

      user = User.find(params[:user_id])
      tweets = user.tweets.order(created_at: :desc)
    else

      tweets = Tweet.includes(:user).order(created_at: :desc)
    end


    if params[:cursor].present?
      cursor_time = Time.at(params[:cursor].to_i)
      tweets = tweets.where('created_at < ?', cursor_time)
    end

    @tweets = tweets.limit(20)
    @next_cursor = @tweets.last&.created_at&.to_i

    render json: {
      tweets: @tweets.as_json(include: { user: { only: [:id, :username, :display_name] } }),
      next_cursor: @next_cursor,
      has_more: @next_cursor.present?
    }
  end

  private

  def cursor_present?
    params[:cursor].present? && params[:cursor] != '0'
  end

  def cursor_time
    Time.at(params[:cursor].to_i)
  end

  def per_page
    params[:per_page] || 20
  end

  def has_more?(tweets)
    return false if @tweets.empty?


    tweets.where('tweets.created_at < ?', @tweets.last.created_at).exists?
  end
end
