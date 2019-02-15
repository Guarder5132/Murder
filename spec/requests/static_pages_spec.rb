require 'spec_helper'

describe "StaticPages" do
    
    subject {page}

    describe "Home page" do
        before { visit root_path }
        it { should have_title(full_title('')) }
        it { should have_content('Home') }
        it { should_not have_title(' | Home') } 

        describe "用户登录后" do
            let(:user) { FactoryGirl.create(:user) }
            before do
                user.microposts.create(content: "开心面对每一天")
                user.microposts.create(content: "善心对待每一人")
                sign_in user
                visit root_path
            end

            it "应该显示所有微博" do
                user.feed.each do |item|
                    expect(page).to have_selector("li##{item.id}", text: item.content)
                end
            end
        end
    end

    describe "about page" do
        before { visit about_path }
        it { should have_title(full_title('About')) }
        it { should have_content('About') }
    end

    describe "help page" do
        before { visit help_path }
        it { should have_title(full_title('Help')) }
        it { should have_content('Help') }
    end

    describe "contact page" do
        before { visit contact_path }
        it { should have_title(full_title('Contact')) }
        it { should have_content('Contact') }
    end

end
