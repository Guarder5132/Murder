require 'spec_helper'

describe "UserPages" do
  
  subject {page}

  describe "new page" do
    before { visit signup_path }
    it { should have_title('Signup') }
    it { should have_content('Signup') }
  end

end
