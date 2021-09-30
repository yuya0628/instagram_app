puts "ダミー投稿"

User.limit(5).each do |user|
  post = user.posts.create(
    body: Faker::Hacker.say_something_smart, 
    remote_images_urls: %w[https://picsum.photos/350/350/?random https://picsum.photos/350/350/?random]
  )
  puts "#{post.id}を作成"
end