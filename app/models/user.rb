class User < ApplicationRecord
  include Clearance::User

  validates :password, length: { minimum: 6 }
end
