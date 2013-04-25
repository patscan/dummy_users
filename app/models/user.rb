class User < ActiveRecord::Base

  include BCrypt

  validates :email, :uniqueness => true
  validates :email, :format => { :with => /^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/,
                                 :message => "must be a valid email address." }
  validates :email,:name, :password_hash, :presence => true
  # validate :ensure_password_entered

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def self.authenticate(email, password)
    user = self.find_by_email(email)

    if user && (user.password != password)
      user = nil
    end
    return user
  end

  # private
  # def ensure_password_entered
  #   unless self.password_hash
  #     self.errors[:password] << "can't be blank"
  #   end
  # end
end

# how to use the active record error messages:
# u.errors.full_messages.each { |m| puts m }

# another way to use it:
# u.errors.messages[:email].each do |m|