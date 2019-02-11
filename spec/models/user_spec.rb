require 'spec_helper'

describe User do
  before{@user = User.new(name: "huahua", email: "huahua@qq.com") }  

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  
  it { should be_valid }

  describe "name" do

    describe "名字为空时" do
      before { @user.name = "" }
      it { should_not be_valid }
    end

  end

  describe "email" do

    describe "邮箱为空时" do
      before { @user.email = "" }
      it { should_not be_valid }
    end

  end
end
