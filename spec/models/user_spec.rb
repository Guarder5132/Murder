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
  it { should respond_to(:admin) }
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:follow!) }
  it { should respond_to(:following?) }
  it { should respond_to(:unfollow!) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }
  
  it { should be_valid }
  it { should_not be_admin }


  describe "关注时" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end
    
    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "作为被关注用户" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end

    describe "取消关注时" do
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
  end

  describe "admin" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

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

  describe "micropost" do
    before { @user.save }
    let!(:old_micropost) { @user.microposts.create(content:"huahua",created_at: 1.day.ago) }
    let!(:new_micropost) { @user.microposts.create(content:"nannan",created_at: 1.hour.ago) }
    
    it "应该按照正确的顺序"  do
      expect(@user.microposts.to_a).to eq [new_micropost, old_micropost]
    end

    it "用户删除后，微博是否也删除" do
      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        expect(Micropost.where(id: micropost.id)).to be_empty
      end
    end

    describe "status" do
      let(:unuser_post) { FactoryGirl.create(:micropost, user: FactoryGirl.create(:user)) }
      let(:followed_user) { FactoryGirl.create(:user) }

      before do
        @user.follow!(followed_user)
        3.times { followed_user.microposts.create!(content: "Lorem ipsum") }
      end

      its(:feed) { should include(new_micropost) } 
      its(:feed) { should include(old_micropost) }
      its(:feed) { should_not include(unuser_post) }
      its(:feed) do
        followed_user.microposts.each do |micropost|
          should include(micropost)
        end
      end
    end
  end
end
