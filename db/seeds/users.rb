puts "ダミー出力"
5.times do
user=User.create!(
  name:Faker::Games::Pokemon.unique.name,
  email: Faker::Internet.unique.email,
  password: "password",
  crypted_password: "password",
)
puts "#{user.name}を作成"
end