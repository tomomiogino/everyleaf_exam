FactoryBot.define do
  factory :user do
    name { 'test1' }
    email { 'test1@example.com' }
    password { '123456' }
    admin { false }
  end

  factory :second_user, class: User do
    name { "admin" }
    email { "admin@example.com" }
    password { "000000" }
    admin { true }
  end
end
