require 'spec_helper'

describe User do
  before{@user = User.new(name: "huahua", email: "huahua@qq.com" , password: "huagege", password_confirmation: "huagege") }  

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token) }

  
  it { should be_valid }

  describe "name" do

    describe "名字为空时" do
      before { @user.name = "" }
      it { should_not be_valid }
    end

    describe "当名字过长时(最大值50)" do
      before { @user.name = "a"*51 }
      it { should_not be_valid }
    end
  end

  describe "email" do

    describe "邮箱为空时" do
      before { @user.email = "" }
      it { should_not be_valid }
    end

    describe "邮箱有效性测试" do
      it "格式无效时" do
        addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@baz.com foo@bar+baz.com]
        addresses.each do |invalid_address|
          @user.email = invalid_address
          expect(@user).not_to be_valid
        end
      end

      it "格式有效时" do
        addresses = %w[user@for.COM A_US-ER@f.b.org first.last@foo.jp a+b@baz.cn]
        addresses.each do |valid_address|
          @user.email = valid_address
          expect(@user).to be_valid
        end
      end
    end

    describe "邮箱相同时，不区分大小写" do
      before do
        user_with_same_eamil = @user.dup
        user_with_same_eamil.email = @user.email.upcase
        user_with_same_eamil.save
      end

      it { should_not be_valid }
    end

    describe "邮箱保存时转换成小写" do
      let(:case_email) {"Foo@ExAmple.CoM"}

      it "应转换成小写" do
        @user.email = case_email
        @user.save
        expect(@user.reload.email).to eq case_email.downcase
      end
    end
    
  end

  describe "password" do
    
    describe "密码为空时" do
      before do
        @user = User.new(name: "huahua", email: "huahua@qq.com" , password: " ", password_confirmation: " ")
      end
      it { should_not be_valid }
    end
    
    describe "密码不相同时" do
      before { @user.password_confirmation = "invalid" }
      it { should_not be_valid }
    end

    describe "密码不小于6位" do
      before { @user.password=@user.password_confirmation="a"*5 }
      it { should_not be_valid }
    end

    describe "authenticate" do
      before { @user.save }
      let(:found_user) { User.find_by(email: @user.email) }

      describe "密码有效时" do
        it { should eq found_user.authenticate(@user.password) }
      end

      describe "密码无效时" do
        let(:user_for_invalid_password) { found_user.authenticate("invalid") }
        
        it { should_not eq user_for_invalid_password }
        specify { expect(user_for_invalid_password).to be_false }
      end
    end
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
end
