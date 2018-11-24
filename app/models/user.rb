class User < ApplicationRecord
  include Clearance::User

  validates :password, length: { minimum: 6 }

  has_many :financial_data
end
