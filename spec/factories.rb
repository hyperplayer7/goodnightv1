FactoryBot.define do
  factory(:user) do
    name { Faker::Name.name }
  end

  factory(:sleep_record) do
    start_time { Faker::Time.between(from: 1.week.ago, to: DateTime.now) }
    end_time { start_time + rand(1..23).hours }
  end
end