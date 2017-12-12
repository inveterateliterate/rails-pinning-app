RSpec.describe FollowersController, type: :controller do

  before(:each) do
    @user = FactoryGirl.create(:user_with_followees)
    @board = @user.boards.first
    login(@user)
  end

  after(:each) do
    if !@user.destroyed?
      Follower.where("follower_id=?", @user.id).destroy_all
      @user.destroy
    end
  end

  describe "GET index" do
    it 'renders the index template' do
      get :index
      expect(response).to render_template("index")
    end

    it 'populates @followed with all followed users' do
      get :index
      expect(assigns[:followers]).to eq(Follower.all)
    end

    it "redirects to login if user is not signed in" do
        logout(@user)
        get :index
        expect(response).to redirect_to(:login)
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

    it 'assigns an instance variable to a new follower' do
        get :new
        expect(assigns(:follower)).to be_a_new(Follower)
    end

    it 'assigns @users to equal the users not followed by @user' do
      get :new, id: @user.id
      expect(assigns[:users]).to eq(@user.not_followed)
    end

    it "redirects to login if user is not signed in" do
        logout(@user)
        get :index
        expect(response).to redirect_to(:login)
    end
  end

  describe "POST create" do
    before(:each) do
      @follower_user = FactoryGirl.create(:user)
      @follower_hash = {
        user_id: @user.id,
        follower_id: @follower_user.id
      }
    end
    after(:each) do
      follower = Follower.where("user_id=? AND follower_id=?", @user.id, @follower_user.id)
      if !follower.empty?
        follower.destroy_all
        @follower_user.destroy
      end
    end

    it 'responds with a redirect' do
      post :create, follower: @follower_hash
      expect(response.redirect?).to be(true) 
    end

    #work on this one
    #it 'creates a follower' do
    #  post :create, follower: @follower_hash
    #  expect(Follower.find_by_follower_id(@follower_user_id).present?).to be(true)
    #end

    it 'redirects to the index view' do
      post :create, follower: @follower_hash
      expect(response).to redirect_to(followers_url)
    end
  end

=begin
  # This should return the minimal set of attributes required to create a valid
  # Follower. As you add validations to Follower, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # FollowersController. Be sure to keep this updated too.
  let(:valid_session) { {} }


  describe "GET #show" do
    it "assigns the requested follower as @follower" do
      follower = Follower.create! valid_attributes
      get :show, params: {id: follower.to_param}, session: valid_session
      expect(assigns(:follower)).to eq(follower)
    end
  end

  describe "GET #new" do
    it "assigns a new follower as @follower" do
      get :new, params: {}, session: valid_session
      expect(assigns(:follower)).to be_a_new(Follower)
    end
  end

  describe "GET #edit" do
    it "assigns the requested follower as @follower" do
      follower = Follower.create! valid_attributes
      get :edit, params: {id: follower.to_param}, session: valid_session
      expect(assigns(:follower)).to eq(follower)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Follower" do
        expect {
          post :create, params: {follower: valid_attributes}, session: valid_session
        }.to change(Follower, :count).by(1)
      end

      it "assigns a newly created follower as @follower" do
        post :create, params: {follower: valid_attributes}, session: valid_session
        expect(assigns(:follower)).to be_a(Follower)
        expect(assigns(:follower)).to be_persisted
      end

      it "redirects to the created follower" do
        post :create, params: {follower: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Follower.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved follower as @follower" do
        post :create, params: {follower: invalid_attributes}, session: valid_session
        expect(assigns(:follower)).to be_a_new(Follower)
      end

      it "re-renders the 'new' template" do
        post :create, params: {follower: invalid_attributes}, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested follower" do
        follower = Follower.create! valid_attributes
        put :update, params: {id: follower.to_param, follower: new_attributes}, session: valid_session
        follower.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested follower as @follower" do
        follower = Follower.create! valid_attributes
        put :update, params: {id: follower.to_param, follower: valid_attributes}, session: valid_session
        expect(assigns(:follower)).to eq(follower)
      end

      it "redirects to the follower" do
        follower = Follower.create! valid_attributes
        put :update, params: {id: follower.to_param, follower: valid_attributes}, session: valid_session
        expect(response).to redirect_to(follower)
      end
    end

    context "with invalid params" do
      it "assigns the follower as @follower" do
        follower = Follower.create! valid_attributes
        put :update, params: {id: follower.to_param, follower: invalid_attributes}, session: valid_session
        expect(assigns(:follower)).to eq(follower)
      end

      it "re-renders the 'edit' template" do
        follower = Follower.create! valid_attributes
        put :update, params: {id: follower.to_param, follower: invalid_attributes}, session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested follower" do
      follower = Follower.create! valid_attributes
      expect {
        delete :destroy, params: {id: follower.to_param}, session: valid_session
      }.to change(Follower, :count).by(-1)
    end

    it "redirects to the followers list" do
      follower = Follower.create! valid_attributes
      delete :destroy, params: {id: follower.to_param}, session: valid_session
      expect(response).to redirect_to(followers_url)
    end
  end
=end
end
