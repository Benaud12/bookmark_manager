require './app/models/user'

describe User do

  let!(:user){create(:user)}

  it 'authenticates when give a valid email address and password' do
    authenticated_user = User.authenticate(user.email, user.password)
    expect(authenticated_user).to eq(user)
  end

  it 'does not authenticate when given an incorrect password' do
    authenticated_user = User.authenticate(user.email, 'not_the_password')
    expect(authenticated_user).to be_nil
  end

end
