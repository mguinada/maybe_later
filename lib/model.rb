#
# === The person for which this application was made
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
  validates_length_of       :password,        minimum: 6, :on => :create

  attr_accessible           :email,
                            :password,
                            :password_confirmation

  before_save               :encrypt_password

  has_many                  :references

  class << self
    def authenticate(email, password)
      user = User.where(email: email).first
      return user if user and user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      nil
    end    
  end

  def references_url?(url)
    references.with_url(url).first.present?
  end

  def create_reference(params)
    raise DuplicateReference if references_url?(params[:url])

    link = Link.where(url: Link.normalize_url(params[:url])).first
    link = Link.new(params) if link.nil?
    params[:link] = link
    
    ref = self.references.new(params)

    raise ReferenceCreationError unless link.save and ref.save 
    ref
  end

  private
  def encrypt_password
    unless password.blank?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end

#
# === A Link that a user saves
#
class Link
  include Mongoid::Document

  field                   :url,         type: String
  field                   :created_at,  type: Time

  validates_uniqueness_of :url  
  validate                :url_format

  has_many                :references

  before_save(on: :create) do
    self.created_at = Time.now
  end

  def url=(str)
    self[:url] = Link.normalize_url(str)
  end

  class << self
    def normalize_url(str)
      return str if str.blank?
      return "http://#{str}" unless str =~ /^(http:\/\/|https:\/\/)/i
      str
    end
  end

  private
  def url_format
    begin
      parsed_url = URI.parse(url)
      errors.add(:url, "is invalid") unless [URI::HTTP, URI::HTTPS].include?(parsed_url.class)
    rescue
      errors.add(:url, "is invalid")
    end    
  end
end

#
# === A User's reference to a link
# 

class Reference
  include Mongoid::Document

  field                   :title,       type: String
  field                   :description, type: String
  field                   :created_at,  type: Time

  belongs_to              :user
  belongs_to              :link

  validates_presence_of   :user, 
                          :link

  validates_uniqueness_of :link, :scope => :user

  before_save(on: :create) do
    self.created_at = Time.now
  end

  class << self
    def with_url(url)
      where(link_id: Link.where(url: Link.normalize_url(url)).first.try(:_id))
    end
  end
end

#
# === DuplicateReference
# 
# Thrown if user attempts to make a reference for a link that he already as referenced before
#
class DuplicateReference < RuntimeError
end

#
# === ReferenceCreationError
# 
# Thrown if reference creation fails by unknown reasons
#
class ReferenceCreationError < RuntimeError
end