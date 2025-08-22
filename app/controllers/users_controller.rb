class UsersController < ApplicationController
  def index
    users = User.all

    if params[:company_id].present?
      users = users.where(company_id: params[:company_id])
    end

    if params[:username].present?
      users = users.where("username ILIKE ?", "%#{params[:username]}%")
    end

    render json: users
  end

  def show
    user = User.find_by!(username: params[:username])
    render json: user
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end


  private

  # def search_params
  #   params.permit(:username)
  # end

end
