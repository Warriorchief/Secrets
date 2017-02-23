class User < ApplicationRecord
  has_secure_password
  has_many :secrets, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :secrets_liked, through: :likes, source: :secret

  validates :name, presence: true
  validates :email, presence: true
  validates :email, format: {with: /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/, message: "proper email format"}
  validates :email, uniqueness: { case_sensitive: false }
  # validates :password, allow_nil: true #only apply validations upon creation
end
