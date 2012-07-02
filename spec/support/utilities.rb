def full_title(page_title)
  base_title = "Ruby on Rails Tutorial Sample App"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end
  
def sign_in(user)
  #calling this method w/ { sign_in user } runs this code, i.e. it
  #signs the user in, see authentication_pages_spec.rb
  visit signin_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
  #Above alone won't work when not using Capybara, hence the next line,
  #for that add the next line
  cookies[:remember_token] = user.remember_token
end
