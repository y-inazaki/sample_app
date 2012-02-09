require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  describe "GET 'home'" do
    it "returns http success" do
      get 'home'
      response.should be_success
    end

    it "should have the right title" do
      get 'home'
      response.should have_selector("title",
				    :content => @base_title + " | Home")
    end

    describe "for signed-in users" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end

      it "should have sidebar" do
        get :home
        response.should have_selector('td.sidebar');
      end

      it "should properly pururalize single micropost" do
        mp1 = Factory(:micropost, :user => @user, :content => "Foo bar")
        get :home
        response.should have_selector('span.microposts', :content => '1 micropost')
      end

      it "should properly pururalize multi microposts" do
        mp1 = Factory(:micropost, :user => @user, :content => "Foo bar")
        mp2 = Factory(:micropost, :user => @user, :content => "Baz quux")
        get :home
        response.should have_selector('span.microposts', :content => '2 microposts')
      end

      it "should paginate microposts" do
        40.times do
          Factory(:micropost, :user => @user, :content => "fooooo")
        end

        get :home
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/?page=2", :content => "2")
        response.should have_selector("a", :href => "/?page=2", :content => "Next")
      end
    end
  end

  describe "GET 'contact'" do
    it "returns http success" do
      get 'contact'
      response.should be_success
    end

    it "should have the right title" do
      get 'contact'
      response.should have_selector("title",
				    :content => @base_title + " | Contact")
    end
  end

  describe "GET 'about'" do
    it "returns http success" do
      get 'about'
      response.should be_success
    end

    it "should have the right title" do
      get 'about'
      response.should have_selector("title",
				    :content => @base_title + " | About")
    end
  end

  describe "GET 'help'" do
    it "returns http success" do
      get 'help'
      response.should be_success
    end

    it "should have the right title" do
      get 'help'
      response.should have_selector("title",
				    :content => @base_title + " | Help")
    end
  end

end
