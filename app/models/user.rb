class User < ApplicationRecord
  validates_presence_of :name
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  validates_presence_of :password_digest

  has_secure_password

  has_many :party_users
  has_many :parties, through: :party_users

  def hosted_parties
    Party.joins(:party_users)
        .where('party_users.user_id = ? AND party_users.is_host = true', id)
  end

  def invited_parties
    Party.joins(:party_users)
        .where('party_users.user_id = ? AND party_users.is_host = false', id)
  end

  def self.all_excluding_id(id)
    User.where.not('id = ?', id)
  end
end
