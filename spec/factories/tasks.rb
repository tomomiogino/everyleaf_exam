FactoryBot.define do
  factory :task do
    title { 'test_title' }
    content { 'test_content' }
    deadline { "#{DateTime.current + 1.days}" }
    status {0}
  end
  factory :second_task, class: Task do
    title { 'second_test_title' }
    content { 'second_test_content' }
    deadline { "#{DateTime.current + 2.days}" }
    status {1}
  end
end
