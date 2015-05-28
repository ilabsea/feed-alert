class Project < ActiveRecord::Base
  belongs_to :owner, class_name: "User"
  belongs_to :user

  has_many :user_projects, dependent: :destroy
  has_many :shared_users, class_name: 'User', through: :user_projects

  validates :name, presence: true

  has_many :alerts

end
