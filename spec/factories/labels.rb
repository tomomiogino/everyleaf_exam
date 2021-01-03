FactoryBot.define do
  factory :label do
    name { "label_1" }
    user
  end

  factory :second_label, class: Label do
    name { "label_2" }
    user
  end
end
