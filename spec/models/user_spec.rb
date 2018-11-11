require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_length_of(:password).is_at_least(6).on(:create) }
end
