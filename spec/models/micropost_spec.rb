require 'spec_helper'

describe Micropost do
  let(:user) { FactoryGirl.create(:user) }
  before { @micropost = user.microposts.build(content: "Lorem ipsum") }

  subject { @micropost }
  
  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should eq user }
  it { should be_valid }

  describe "当user_id不存在时" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end

  describe "微博内容为空时" do
    before { @micropost.content = "" }
    it { should_not be_valid }
  end

  describe "微博内容过长时" do
    before { @micropost.content = "a"*151 }
    it { should_not be_valid }
  end

end
