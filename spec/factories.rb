FactoryGirl.define do
    factory :user do
        sequence(:name)  { |n| "Perseon #{n}" }
        sequence(:email) { |n| "person_#{n}@example.com" }
        # name "Michael Hartl"
        # email "michael@example.com"
        password "foobar"
        password_confirmation "foobar"

        factory :admin do
            admin true
        end
    end

    factory :micropost do
        content "Lorem ipsum"
        user
    end
end