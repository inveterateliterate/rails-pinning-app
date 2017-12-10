class UsersController < ApplicationController
  before_action :require_login, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
    @pins = current_user.pins.all
  end

  def login
  end

  def new
    @user = User.new
  end

  def authenticate
    @user = User.authenticate(params[:email], params[:password])
    if @user.nil?
      @error = "Your email or password is incorrect. Please try again."
      render :login      
    else
      session[:user_id] = @user.id    
      redirect_to user_path(@user)
    end
  end

  def logout
    session.delete(:user_id)
    redirect_to login_path
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end
end
