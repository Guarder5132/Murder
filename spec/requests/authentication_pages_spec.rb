require 'spec_helper'

describe "Authentication Pages" do
  
  subject { page }

  describe "signin page" do
    before { visit signin_path }
    it { should have_title(full_title('Sign in')) }
    it { should have_content('Sign in') }
  end

  describe "signin" do
    before { visit signin_path }

    describe "信息无效时" do
      before { click_button "Sign in" }

      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }
    end

    describe "信息有效时" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",       with: user.email.upcase
        fill_in "Password",    with: user.password
        click_button 'Sign in'
      end

      it { should have_title(user.name) }
      it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Sign out',    href: signout_path) }
      it { should have_link('Settings',    href: edit_user_path(user)) }
      it { should have_link('Users',       href: users_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe "退出时" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
  end

  describe "是否受到保护" do
    
    describe "于非登录用户" do  
      let(:user) { FactoryGirl.create(:user) }

      describe "访问用户编辑界面时" do
        before { visit edit_user_path(user) }
        it { should have_title('Sign in') }
      end

      describe "向用户提交更新动作时" do
        before { patch user_path(user) }
        specify { expect(response).to redirect_to( signin_path) }
      end

      describe "访问所有用户列表时" do
        before { visit users_path }
        it { should have_title('Sign in') }
      end
      
      describe "提交删除动作时" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(signin_path) }
      end

      describe "在微博控制器里提交创建行动" do
        before { post microposts_path }
        specify { expect(response).to redirect_to(signin_path) }
      end

      describe "在微博控制器里提交删除动作" do
        before { delete micropost_path(FactoryGirl.create(:micropost)) }
        specify { expect(response).to redirect_to(signin_path) }
      end
    end

    describe "于登录的用户" do
      let(:user) { FactoryGirl.create(:user) }
      let(:qt_user) {FactoryGirl.create(:user, email: "nansheng@example.com")}
      before { sign_in user, no_capybara:true }

      describe "访问其他用户编辑页面时" do
        before { visit edit_user_path(qt_user) }
        it { should_not have_title(full_title('Edit')) }
      end

      describe "向其他用户提交update动作时" do
        before { patch user_path(qt_user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end

    describe "非管理员用户" do
      let(:user) { FactoryGirl.create(:user) }
      let(:no_admin) { FactoryGirl.create(:user) }

      before { sign_in no_admin, no_capybara:true }

      describe "向用户提交删除动作时" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end
  end
end
