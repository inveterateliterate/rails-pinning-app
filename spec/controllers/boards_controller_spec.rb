require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe BoardsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Board. As you add validations to Board, be sure to
  # adjust the attributes here as well.
  #let(:valid_attributes) {
   # skip("Add a hash of attributes valid for your model")
  #}

  #let(:invalid_attributes) {
  #  skip("Add a hash of attributes invalid for your model")
  #}

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # BoardsController. Be sure to keep this updated too.
  #let(:valid_session) { {} }
  before(:each) do
    @user = FactoryGirl.create(:user_with_boards_and_followers)
    @board = @user.boards.first
    login(@user)
  end
  after(:each) do
    if !@user.destroyed?
      @user.board_pinners.destroy_all
      @user.pinnings.destroy_all
      @user.boards.destroy_all
      @user.destroy
    end
  end

  describe "GET #index" do
    it "assigns @boards to be the users pinnable boards" do     
      get :index
      expect(assigns(:boards)).to eq(@user.pinnable_boards)
    end
  end

  describe "GET new" do
    it 'responds with success' do
      get :new
      expect(response.success?).to be(true)
    end

    it 'renders the new view' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'assigns an instance variable to a new board' do
      get :new
      expect(assigns(:board)).to be_a_new(Board)
    end

    it "redirects to login if user is not signed in" do
      logout(@user)
      get :new
      expect(response).to redirect_to(:login)
    end
  end

  describe 'POST create' do
    before(:each) do
      @board_hash = {
        name: "My Pins!"
      }
    end

      after(:each) do
        board = Board.find_by_name("My Pins!")
        if !board.nil?
          board.destroy
        end
      end


    it 'responds with a redirect' do
      post :create, board: @board_hash
      expect(response.redirect?).to be(true)
    end
 
    it 'creates a board' do
      post :create, board: @board_hash
      expect(Board.find_by_name("My Pins!").present?).to be(true)
    end
 
    it 'redirects to the show view' do
      post :create, board: @board_hash
      expect(response).to redirect_to(board_url(assigns(:board)))
    end
 
    it 'redisplays new form on error' do
    # The name is required in the Board model, so we'll
    # make the name nil to test what happens with invalid parameters
      @board_hash[:name] = nil
      post :create, board: @board_hash
      expect(response).to render_template(:new)
    end

    it 'assigns the @errors instance variable on error' do
    # The name is required in the Board model, so we'll
    # make the name nil to test what happens with invalid parameters
      @board_hash[:name] = ""
      post :create, board: @board_hash
      expect(assigns[:board].errors.any?).to be(true)
    end

    it "redirects to login if user is not signed in" do
      logout(@user)
      get :edit, id: @board.id
      expect(response).to redirect_to(:login)
  end
end

describe "GET #show" do
  it 'assigns the requested board as @board' do
    get :show, id: @board.id
    expect(assigns[:board]).to eq(@board)
  end

  it 'assigns the @pins variable with the boards pins' do
    get :show, id: @board.id
    expect(assigns[:pins]).to eq(@board.pins)
  end
end

describe "GET #edit" do
  it 'responds with success' do
    get :edit, id: @board.id
    expect(response.success?).to be(true)
  end

  it 'renders the edit view' do
    get :edit, id: @board.id
    expect(response).to render_template(:edit)
  end

  it 'assigns an instance variable to a new board' do
    get :edit, id: @board.id
    expect(assigns(:board)).to eq(@board)
  end

  it "redirects to login if user is not signed in" do
      logout(@user)
      get :edit, id: @board.id
      expect(response).to redirect_to(:login)
  end

  it "sets @followers to the user's followers" do
    get :edit, id: @board.id
    expect(assigns[:followers]).to eq(@user.user_followers)
  end
end

describe "PUT #update" do
  before(:each) do
    @board_hash = {
      name: @board.name
    }
  end

  it 'responds with a redirect' do
    put :update, board: @board_hash, id: @board.id
    expect(response.redirect?).to be(true)
  end 

  it 'updates a board' do
    @board_hash[:name] = "New Name"
    put :update, id: @board.id, board: @board_hash
    expect(@board.reload.name).to eq("New Name")
  end

  it 'redirects to the show view' do
    @board_hash[:name] = "New Name"
    put :update, id: @board.id, board: @board_hash
    @board.reload
    expect(response).to redirect_to(:board)
  end

  it 'redisplays edit form on error' do
    @board_hash[:name] = ""
    put :update, id: @board.id, board: @board_hash
    expect(response).to render_template(:edit)
  end

  it 'assigns the @errors instance variable on error' do
    @board_hash[:name] = ""
    put :update, id: @board.id, board: @board_hash
    expect(assigns[:board].errors.any?).to be(true)
  end

  it "redirects to login if user is not signed in" do
      logout(@user)
      get :edit, id: @board.id
      expect(response).to redirect_to(:login)
  end

  it 'creates a BoardPinning' do
    # We get the user's first follower - this is the one we want to let pin on @board
    user_to_let_pin = @user.followers.first
 
    # Now we're updating the hash we pass in to add 
    # board_pinners_attributes with our user_id
    @board_hash[:board_pinners_attributes] = []      
    @board_hash[:board_pinners_attributes] << {user_id: user_to_let_pin.user_id, board_id: @board.id}
 
    put :update, id: @board.id, board: @board_hash
 
    # Then we expect this record to have been created
    board_pinner = BoardPinner.where("user_id=? AND board_id=?", user_to_let_pin.user_id, @board.id)
    expect(board_pinner.present?).to be (true)
 
    # Let's clean up here
    if board_pinner.present?
      board_pinner.destroy_all
    end
  end
end

=begin
  describe "DELETE #destroy" do
    it "destroys the requested board" do
      board = Board.create! valid_attributes
      expect {
        delete :destroy, params: {id: board.to_param}, session: valid_session
      }.to change(Board, :count).by(-1)
    end

    it "redirects to the boards list" do
      board = Board.create! valid_attributes
      delete :destroy, params: {id: board.to_param}, session: valid_session
      expect(response).to redirect_to(boards_url)
    end
  end
=end
end
