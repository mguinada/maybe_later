#
# === The person for which this application was mande
#
class User
  include Mongoid::Document

  attr_accessor             :password

  field                     :email,           type: String
  field                     :password_hash,   type: String
  field                     :password_salt,   type: String
  field                     :last_sign_in_at, type: Time

  validates_format_of       :email,           with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_presence_of     :email
  validates_uniqueness_of   :email
  validates_presence_of     :password,        :on => :create
  validates_confirmation_of :password
  validates_length_of       :password,        minimum: 6

  attr_accessible           :email,
                            :password,
                            :password_confirmation

  before_save               :encrypt_password

  def self.authenticate(email, password)
    user = User.where(email: email).first
    return user if user and user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
    nil
  end

  private
  def encrypt_password
    unless password.nil? or password.empty?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end