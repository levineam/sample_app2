require 'spec_helper'

describe "Charity pages" do
  
  subject { page }
  
  describe "create charity page" do
    before { visit create_charity_path }
    
    it { should have_selector('h1',   text: 'Create Charity') }
    it { should have_selector('title',text: full_title('Create Charity')) }
  end
end
  
