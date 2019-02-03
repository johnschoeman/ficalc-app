class User < ApplicationRecord
  include Clearance::User

  validates :password, length: { minimum: 6 }

  has_many :financial_data

  def has_financial_data?
    financial_data.count != 0
  end
end
