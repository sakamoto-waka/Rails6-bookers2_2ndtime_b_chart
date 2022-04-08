User.create!(name: 'aaaa',
            email: 'aaaa@gmail.com',
            password: 'aaaaaa')

10.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@gmail.com"
  password = 'password'
  User.create!(name: name,
              email: email,
              password: password)
end

# books
users = User.order(:created_at).take(6)
3.times do
  title = Faker::Book.title
  body = Faker::Lorem.sentence(word_count: 5)
  
  users.each { |user| user.books.create!(title: title, body: body) }
end