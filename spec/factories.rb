FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}   
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
end
