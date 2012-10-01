FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }   
    password "foobar"
    password_confirmation "foobar"
        
        factory :admin do
            admin true
        #  factory Allows us to use FactoryGirl.create(:admin)to create an
        #administrative user in our tests, which lets us test for the
        #delete functionality
        #  
        end
    end
    #Here sequence takes a symbol corresponding to the desired attribute
    #(such as :name) and a block with one variable, which we have called
    #"n." Upon successive invocations of the FactoryGirl method
    #(FactoryGirl.create(:user)), the block variable is auto incremented
    
    factory :micropost do
        content "Lorem ipsum"
        user
    end
    # tell Factory Girl about the micropost’s associated user just by
    #including a user in the definition of the factory
    # this allows us to define factory microposts as follows:
    #FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    # the tests made that don't use this factory only test for the
    #existence of the microposts attribute, these factories allow us to
    #test that user.microposts and user.charities actually returns an
    #array with the desired data

    factory :charity do
      sequence(:name)        { |n| "charity #{n}" }
      sequence(:summary)     { |n| "summary #{n}" }
      sequence(:description) { |n| "description #{n}" }
    end
end

