class User < ActiveRecord::Base
  attr_accessible :email, :username, :password, :password_confirmation
  attr_accessor :password
  before_save :encrypt

  validates_presence_of :email
  validates_presence_of :username
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password

  validates_uniqueness_of :email
  validates_uniqueness_of :username

  def encrypt
  	if self.password.present?
  		self.password_salt = BCrypt::Engine.generate_salt
  		self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
  	end
  end

  def User.authenticate(email, password)
  	user = User.find_by_email(email)
  	if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
  		return user
  	else
  		nil
  	end
  end

  def User.facebook_thing(url)
    return open(url).read
  end
end
