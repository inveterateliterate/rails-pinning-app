  class BoardsController < ApplicationController
  before_action :require_login, only: [:new, :create, :edit, :update, :destroy]

  def index
    @boards = current_user.pinnable_boards
  end

  def show
    @board = Board.find(params[:id])
    @pins = @board.pins
  end

  def new
    @board = Board.new
    @followers = current_user.user_followers
  end

  def edit
    @board = Board.find(params[:id])
    @followers = current_user.user_followers
  end

  def create
    @board = Board.new(board_params)
    respond_to do |format|
      if @board.save        
        format.html { redirect_to @board, notice: 'Board was successfully created.' }
        format.json { render :show, status: :created, location: @board }
      else
        format.html { render :new }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @board = Board.find(params[:id])
    respond_to do |format|
      if @board.update(board_params)
        format.html { redirect_to @board, notice: 'Board was successfully updated.' }
        format.json { render :show, status: :ok, location: @board }
      else
        format.html { render :edit }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @board.destroy
    respond_to do |format|
      format.html { redirect_to boards_url, notice: 'Board was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_board
    @board = Board.find(params[:id])
  end

  def board_params
    params.require(:board).permit(:name, :user_id, board_pinners_attributes: [:user_id, :board_id])
  end
end
