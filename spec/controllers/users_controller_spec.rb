RSpec.describe UsersController, type: :controller do
  before(:each) do
    @user = FactoryGirl.build(:user)
  end

  after(:each) do
    @user.destroy if !@user.destroyed?
  end

  let(:valid_attributes) {
    { 
      first_name: @user.first_name,
      last_name: @user.last_name,
      email: @user.email,
      password: @user.password
    }
  }

  let(:invalid_attributes) {
    {
      first_name: @user.first_name,
      last_name: nil,
      email: nil,
      password: @user.password
    }
  }

  let(:valid_session) { {} }

  describe 'GET #show' do
    it 'assigns the requested user as @user' do
      user = User.create! valid_attributes
      post :authenticate, {email: user.email, password: user.password}
      get :show, {:id => user.to_param}, valid_session
      expect(assigns(:user)).to eq(user)
    end

    it 'redirects to login if user is not signed in' do
      user = User.create! valid_attributes
      get :show, {:id => user.to_param}, valid_session
      expect(response).to redirect_to(:login)
    end
  end

  describe 'GET /login' do
    it 'renders the login view' do
      get :login
      expect(response).to render_template('login')
    end
  end

  describe 'POST login' do
    before(:all) do
      @user = User.create!(first_name: 'skill', last_name: 'crush', email: 'coder@skillcrush.com', password: 'secret')
      @valid_user_hash = {first_name: @user.first_name, last_name: @user.last_name ,email: @user.email, password: @user.password}
      @invalid_user_hash = {first_name: '', last_name: '', email: '', password: ''}
    end
  
    after(:all) do
      @user.destroy if !@user.destroyed?
    end

    it 'renders the show view if params valid' do
      user = User.create! valid_attributes
      post :authenticate, {email: user.email, password: user.password}
      expect(response).to redirect_to(user_path(user))
    end

    it 'populates @user if params valid' do 
      user = User.create! valid_attributes
      post :authenticate, {email: user.email, password: user.password}
      expect(assigns :user).to eq(user)
    end

    it 'renders the login view if params invalid' do
      user = User.create! valid_attributes
      post :authenticate, {email: '', password: ''}
      expect(response).to render_template('login')    
    end

    it 'populates the @errors variable if params invalid' do
      user = User.create! valid_attributes
      post :authenticate, {email: '', password: ''} 
      expect(assigns[:error].present?).to be(true)
    end
  end

  describe 'GET #new' do
    it 'assigns a new user as @user' do
      get :new, params: {}, session: valid_session
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'GET #edit' do
    it 'redirects to login if user is not signed in' do
      user = User.create! valid_attributes
      get :edit, {:id => user.to_param}, valid_session
      expect(response).to redirect_to(:login)
    end
    
    it 'assigns the requested user as @user' do
      user = User.create! valid_attributes
      post :authenticate, { email: user.email, password: user.password }
      get :edit, {id: user.to_param}, valid_session
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new User' do
        expect {
          post :create, {:user => valid_attributes}, valid_session
        }.to change(User, :count).by(1)
      end

      it 'assigns a newly created user as @user' do
        post :create, {:user => valid_attributes}, valid_session
        expect(assigns(:user)).to be_a(User)
        expect(assigns(:user)).to be_persisted
      end

      it 'redirects to the created user' do
        post :create, {:user => valid_attributes}, valid_session
        expect(response).to redirect_to(User.last)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved user as @user' do
        post :create, {:user => invalid_attributes}, valid_session
        expect(assigns(:user)).to be_a_new(User)
      end

      it 're-renders the new template' do
        post :create, {:user => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {  { first_name: 'new name' } }

      it 'redirects to login if user is not signed in' do
        user = User.create! valid_attributes
        put :update, {:id => user.to_param}, valid_session
        expect(response).to redirect_to(:login)
      end

      it 'updates the requested user' do
        user = User.create! valid_attributes
        post :authenticate, {email: user.email, password: user.password}
        put :update, {id: user.to_param, user: new_attributes}, valid_session
        user.reload
        skip('Add assertions for updated state')
      end

      it 'assigns the requested user as @user' do
        user = User.create! valid_attributes
        post :authenticate, {email: user.email, password: user.password}
        put :update, {id: user.to_param, user: valid_attributes}, valid_session
        expect(assigns(:user)).to eq(user)
      end

      it 'redirects to the user' do
        user = User.create! valid_attributes
        post :authenticate, {email: user.email, password: user.password}
        put :update, {id: user.to_param, user: valid_attributes}, valid_session
        expect(response).to redirect_to(user)
      end
    end

    context 'with invalid params' do
      it 'assigns the user as @user' do
        user = User.create! valid_attributes
        post :authenticate, {email: user.email, password: user.password}
        put :update, {id: user.to_param, user: invalid_attributes}, valid_session
        expect(assigns(:user)).to eq(user)
      end

      it "re-renders the 'edit' template" do
        user = User.create! valid_attributes
        post :authenticate, {email: user.email, password: user.password}
        put :update, {id: user.to_param, user: invalid_attributes}, valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'redirects to login if user is not signed in' do
      user = User.create! valid_attributes
      delete :destroy, {:id => user.to_param}, valid_session
      expect(response).to redirect_to(:login)
    end

    it 'destroys the requested user' do
      user = User.create! valid_attributes
      post :authenticate, {email: user.email, password: user.password}
      expect {
        delete :destroy, {id: user.to_param}, valid_session
      }.to change(User, :count).by(-1)
    end

    it 'redirects to the users list' do
      user = User.create! valid_attributes
      post :authenticate, {email: user.email, password: user.password}
      delete :destroy, {id: user.to_param}, valid_session
      expect(response).to redirect_to(users_url)
    end
  end
end
