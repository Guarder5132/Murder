require 'spec_helper'

describe "MicropostPages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "微博创建" do
    before { visit root_path }

    describe "信息无效时" do
      
      it "应该发送失败" do
        expect { click_button "发送微博" }.not_to change(Micropost, :count)
      end

      describe "失败后显示消息" do
        before { click_button "发送微博" }
        it { should have_content('error') }
      end
    end

    describe "信息有效时" do
      before do
        fill_in 'micropost_content', with: "Nihao tutu"
      end

      it "应该创建成功" do
        expect { click_button "发送微博" }.to change(Micropost, :count).by(1)
      end
    end
  end

  describe "微博删除" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "为当前用户" do
      before {visit root_path}

      it "应该删除成功" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end
end
