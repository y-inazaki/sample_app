require 'spec_helper'

describe UsersController do
  render_views

  describe "Get 'show'" do

    before(:each) do
      @user = Factory(:user)

      # without db, 
      # User.stub(!:find, @user.id).and_return(@user)
      # any call to User.find with the given id will return @user
      # Pros
      #  it separates the controller tests from the model layer.
      # Cons
      #  Error message subtle
    end

    it "should be successful" do 
      get :show, :id => @user	# automatically use @user.id
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end

    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end

    it "should include the user's name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end

    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar")
      #response.should have_selector("h1>img", :alt => "Gravatar")
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Sign up")
    end
  end

  describe "POST 'create'" do

    describe "failure" do

      before(:each) do
	@attr = { :name => "", :email => "", :password => "",
	      :password_confirmation => "" }
      end

      it "should not create a user" do
	lambda do
	  post :create, :user => @attr
	end.should_not change(User, :count)
      end

      it "should have the right title" do
	# failed signup attempt -> re-render the new user page
	post :create, :user => @attr
	response.should have_selector("title", :content => "Sign up")
      end

      it "should render the 'new' page" do
	# failed signup attempt -> re-render the new user page
	post :create, :user => @attr
	response.should render_template('new')
      end
    end

    describe "success" do

      before(:each) do
	@attr = { :name => "New User", :email => "user@example.com",
		:password => "foobar", :password_confirmation => "foobar" }
      end

      it "should create a user" do
	lambda do
	  post :create, :user => @attr
	end.should change(User, :count).by(1)
      end

      it "should redirect to the user show page" do
	post :create, :user => @attr
	response.should redirect_to(user_path(assigns(:user)))
      end

      it "should have a welcome message" do
	post :create, :user => @attr
	flash[:success].should =~ /welcome to the sample app/i
      end
    end
  end

end