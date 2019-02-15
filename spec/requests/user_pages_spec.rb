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
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "nihao") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "wohao") }  
    before { visit user_path(user) }
    it { should have_title(user.name) }
    it { should have_content(user.name) }

    it { should have_content(m1.content) }
    it { should have_content(m2.content) }
    it { should have_content(user.microposts.count) }
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

      describe "创建成功后应该登录用户" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'hua@qq.com') }
        
        it { should have_title(user.name) }
        it { should have_link('Sign out') }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_title('Edit') }
      it { should have_content('Update') }
    end

    describe "信息无效" do
      before { click_button "更新信息" }
      it { should have_content('error') }
    end

    describe "信息有效" do
      let(:new_name) { "huahua" }
      let(:new_email){ "hua@example.com" }
      before do
        fill_in "Name",     with: new_name
        fill_in "Email",    with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "更新信息"
      end

      it { should have_title(new_name) }
      it { should have_link('Sign out', href: signout_path) }
      it { should have_selector('div.alert.alert-success') }
      specify { expect(user.reload.name).to eq new_name }
      specify { expect(user.reload.email).to eq new_email } 
    end 

  end

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All users') }

    describe "分页" do
      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "应该显示所有用户" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name) 
        end
      end
    end

    describe "删除用户" do
      it { should_not have_link('delete') }

      describe "作为管理员用户" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "应该删除用户" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end

        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end
end
