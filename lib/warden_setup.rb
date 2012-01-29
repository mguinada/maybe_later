Warden::Manager.serialize_into_session{|user| user._id }
Warden::Manager.serialize_from_session{|id| User.where(_id: id).first }

Warden::Manager.after_authentication do |user, auth, opts|
  user.update_attribute(:last_sign_in_at, Time.now)
end

Warden::Manager.before_logout do |user, auth, opts|
  puts "SIGNED OUT"
end

Warden::Strategies.add(:email_and_password) do
  def valid?
    params['email'] || params['password']
  end

  def authenticate!
    user = User.authenticate(params['email'], params['password'])
    user.nil? ? fail!("Could not log in") : success!(user)
  end
end

