require 'spec_helper'

describe Relationship do
  
  let(:follower) { FactoryGirl.create(:user) }
  let(:followed) { FactoryGirl.create(:user) }
  let(:relationship) { follower.relationships.build(followed_id: followed.id) }
  
  subject { relationship }

  it { should be_valid }

  describe "模型之间的关系测试" do  
    it { should respond_to(:follower) }
    it { should respond_to(:followed) }
    its(:follower) { should eq follower }
    its(:followed) { should eq followed }
  end 

  describe "当follower_id为空时" do
    before { relationship.follower_id = nil }
    it { should_not be_valid }
  end

  describe "当followed_id为空时" do
    before { relationship.followed_id = nil }
    it { should_not be_valid }
  end
end
