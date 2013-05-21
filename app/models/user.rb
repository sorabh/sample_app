require 'digest/sha2'
class User < ActiveRecord::Base
  attr_accessible :contact_no, :f_name, :l_name, :npi, :user_name  ,:password ,:password_confirmation

  validates :user_name ,:npi ,:contact_no ,:presence  =>true ,:uniqueness => true
  validates :password, :confirmation => true
  attr_accessor :password_confirmation
  attr_reader   :password
  validate  :password_must_be_present

  def User.authenticate(name, password)
    if user = find_by_user_name(name)
      puts "hello";
      if user.hashed_password == encrypt_password(password, user.salt)
        user
      end
    end
  end

  def User.encrypt_password(password, salt)
    Digest::SHA2.hexdigest(password + "wibble" + salt)
  end

  # 'password' is a virtual attribute
  def password=(password)
    @password = password

    if password.present?
      generate_salt
      self.hashed_password = self.class.encrypt_password(password, salt)
    end
  end

  private

  def password_must_be_present
    errors.add(:password, "Missing password") unless hashed_password.present?
  end

  def generate_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
end


