
class Users::TweetsController < ApplicationController
  before_action :set_user

  def index
    tweets = @user.tweets.order(created_at: :desc)

    if params[:cursor].present?
      cursor_time = Time.at(params[:cursor].to_i)
      tweets = tweets.where('created_at < ?', cursor_time)
    end

    @tweets = tweets.limit(20)
    @next_cursor = @tweets.last&.created_at&.to_i

    render json: {
      tweets: @tweets,
      next_cursor: @next_cursor,
      has_more: @next_cursor.present?
    }
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
