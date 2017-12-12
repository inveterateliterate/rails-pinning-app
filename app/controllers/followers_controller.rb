class FollowersController < ApplicationController
  before_action :require_login, only: [:index, :new, :create, :destroy]

  def index
    @followers = Follower.all
    @followed = current_user.followed
  end

  def new
    @follower = Follower.new
    @users = current_user.not_followed
  end

  def create
    @follower = Follower.new(follower_params)

    respond_to do |format|
      if @follower.save
        @followed = current_user.followed
        format.html { redirect_to followers_path }
        format.json { render :show, status: :created, location: @follower }
      else
        format.html { render :new }
        format.json { render json: @follower.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @follower = Follower.find(params[:id])
    @follower.destroy
    respond_to do |format|
      format.html { redirect_to followers_url, notice: 'Follower was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def follower_params
    params.require(:follower).permit(:user_id, :follower_id)
  end
end
