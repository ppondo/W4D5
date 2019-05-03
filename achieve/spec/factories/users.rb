# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  session_token   :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryBot.define do
  factory :user do 
    name { Faker::Movies::StarWars.character }
    password { "password" }
  end
end
