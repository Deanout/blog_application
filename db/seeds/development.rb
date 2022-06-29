# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

def seed_users
  dean = User.create(email: 'dean@example.com',
                     password: 'password',
                     password_confirmation: 'password',
                     first_name: 'Dean',
                     last_name: 'DeHart',
                     role: User.roles[:admin])

  john = User.create(email: 'john@doe.com',
                     password: 'password',
                     password_confirmation: 'password',
                     first_name: 'John',
                     last_name: 'Doe')
end

def seed_addresses
  Address.create(street: '123 Main St',
                 city: 'Anytown',
                 state: 'CA',
                 zip: '12345',
                 country: 'USA',
                 user: User.first)
  Address.create(street: '123 Main St',
                 city: 'Anytown',
                 state: 'CA',
                 zip: '12345',
                 country: 'USA',
                 user: User.second)
end

def seed_categories
  Category.create(name: 'Uncategorized', display_in_nav: true)
  Category.create(name: 'General', display_in_nav: true)
  Category.create(name: 'Finance', display_in_nav: true)
  Category.create(name: 'Health', display_in_nav: false)
  Category.create(name: 'Education', display_in_nav: false)
end

def seed_posts_and_comments
  posts = []
  dean =  User.first
  john = User.second
  category = Category.first
  10.times do |x|
    puts "Creating post #{x}"
    post = Post.new(title: "Title #{x}",
                    body: "Body #{x} Words go here Idk",
                    user: dean,
                    category: category)

    5.times do |y|
      puts "Creating comment #{y} for post #{x} with user #{john.email}"
      post.comments.build(body: "Comment #{y}",
                          user: john)
    end

    posts.push(post)
  end
  Post.import(posts, recursive: true)
end

def seed_ahoy
  Ahoy.geocode = false
  request = OpenStruct.new(
    params: {},
    referer: 'http://example.com',
    remote_ip: '0.0.0.0',
    user_agent: 'Internet Explorer, lol can you imagine?',
    original_url: 'rails'
  )

  visit_properties = Ahoy::VisitProperties.new(request, api: nil)
  properties = visit_properties.generate.select { |_, v| v }

  example_visit = Ahoy::Visit.create!(properties.merge(
                                        visit_token: SecureRandom.uuid,
                                        visitor_token: SecureRandom.uuid
                                      ))

  2.months.ago.to_date.upto(Date.today) do |date|
    Post.all.each do |post|
      rand(1..5).times do |_x|
        Ahoy::Event.create!(name: 'Viewed Post',
                            visit: example_visit,
                            properties: { post_id: post.id },
                            time: date.to_time + rand(0..23).hours + rand(0..59).minutes)
      end
    end
  end
end

elapsed = Benchmark.measure do
  puts 'Seeding development database...'
  seed_users
  seed_addresses
  seed_categories
  seed_posts_and_comments
  seed_ahoy
end

puts "Seeded development DB in #{elapsed.real} seconds"
