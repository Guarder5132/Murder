require 'spec_helper'

describe "StaticPages" do
    
    subject {page}

    describe "Home" do
        before { visit root_path }
        it { should have_title(full_title('')) }
        it { should have_content('Home') }
        it { should_not have_title(' | Home') } 
    end

    describe "about" do
        before { visit about_path }
        it { should have_title(full_title('About')) }
        it { should have_content('About') }
    end

    describe "help" do
        before { visit help_path }
        it { should have_title(full_title('Help')) }
        it { should have_content('Help') }
    end

    describe "contact" do
        before { visit contact_path }
        it { should have_title(full_title('Contact')) }
        it { should have_content('Contact') }
    end

end
