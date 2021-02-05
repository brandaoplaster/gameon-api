FactoryBot.define do
  factory :license do
    key { Faker::Lorem.characters(number: 15) }
    platform { :game_on }
    status { :available }
    game
  end
end
