class User < ActiveRecord::Base
  validates :email, :password, presence: true
  validates :email, email: true
  validates :password, length: { in: 6..72}

  has_secure_password

  def self.authenticate(email, password)
    user = User.find_by!(email: email.downcase)
    user.authenticate(password)
  rescue ActiveRecord::RecordNotFound
    false
  end
end
