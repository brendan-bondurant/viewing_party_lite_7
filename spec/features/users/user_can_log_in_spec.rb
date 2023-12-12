require 'rails_helper'

# As a registered user
# When I visit the landing page `/`
# I see a link for "Log In"
# When I click on "Log In"
# I'm taken to a Log In page ('/login') where I can input my unique email and password.
# When I enter my unique email and correct password 
# I'm taken to my dashboard page
RSpec.describe "Logging In" do
  it "can log in with valid credentials" do
    user = User.create(name: "test test", email: "test@test.com", password: "test")

    visit '/'

    expect(page).to have_link('Log In')
    click_link 'Log In'
    expect(current_path).to eq('/login')

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    expect(page).to have_button('Log In')
    click_button 'Log In'

    expect(current_path).to eq(user_path(User.last.id))

    expect(page).to have_content("Welcome, #{user.name}")
  end
  # As a registered user
  # When I visit the landing page `/`
  # And click on the link to go to my dashboard
  # And fail to fill in my correct credentials 
  # I'm taken back to the Log In page
  # And I can see a flash message telling me that I entered incorrect credentials. 
  it 'flashes error with incorrect credentials' do
    user = User.create(name: "test test", email: "test@test.com", password: "test")
    visit '/'
    expect(page).to have_link('Log In')
    click_link 'Log In'
    expect(current_path).to eq('/login')

    fill_in :email, with: user.email
    fill_in :password, with: "wrong"

    click_button 'Log In'
    expect(current_path).to eq('/login')
    expect(page).to have_content('Invalid Credentials')

  end

end