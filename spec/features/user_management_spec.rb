feature 'User sign up' do

  scenario 'I can sign up as a new user' do
    user = build :user
    expect { sign_up(user) }.to change(User, :count).by(1)
    expect(page).to have_content('Welcome, foo@bar.com')
    expect(User.first.email).to eq('foo@bar.com')
  end

  scenario 'requires a matching confirmation password' do
    user = build(:user, password_confirmation: 'wrong')
    expect { sign_up(user) }.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content 'Password and confirmation password do not match.'
  end

  scenario 'user doesn\'t provide an email address' do
    user = build(:user, email: '')
    expect {sign_up(user)}.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content 'Email required.'
  end

  scenario 'email is already in database' do
    user = build(:user)
    sign_up(user)
    expect{sign_up(user)}.not_to change(User, :count)
    expect(page).to have_content('Email taken.')
  end

  scenario 'email needs to be valid email format' do
    user = build(:user, email: 'bobby')
    expect{sign_up(user)}.not_to change(User, :count)
    expect(page).to have_content("Dude, that's not an email!")
  end

end

feature 'User log in' do

  let(:user){build(:user)}

  before(:each) do
    sign_up(user)
  end

  scenario 'correct credentials' do
    sign_in(user)
    expect(page).to have_content "Welcome, #{user.email}"
  end

end



feature 'User log out' do

  let(:user){build(:user)}

  before(:each) do
    sign_up(user)
    sign_in(user)
  end

  scenario 'correct credentials' do
    click_button 'Sign out'
    expect(page).to have_content "Goodbye!"
    expect(page).not_to have_content "Welcome, foo@bar.com"
  end

end


