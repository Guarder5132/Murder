require 'spec_helper'

describe "UserPages" do
  
  subject {page}

  describe "signup page" do
    before { visit signup_path }
    it { should have_title('Sign up') }
    it { should have_content('Sign up') }
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    it { should have_title(user.name) }
    it { should have_content(user.name) }
  end

  describe "signup" do
    before { visit signup_path }
    let(:submit) { "创建用户" }

    describe "消息无效时" do
      it "应该无法创建用户" do
        expect{ click_button submit }.not_to change(User, :count) 
      end
    end

    describe "消息有效时" do
      before do
        fill_in "Name",           with:"Huahua" 
        fill_in "Email",          with:"hua@qq.com"
        fill_in "Password",       with:"huahua"
        fill_in "Confirmation",   with:"huahua"
      end

      it "应该创建用户成功" do
        expect{ click_button submit }.to change(User, :count).by(1)
      end
    end
  end

end
