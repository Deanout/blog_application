# run seed file based on environment
puts 'Seeding database'
load(Rails.root.join('db', 'seeds', "#{Rails.env.downcase}.rb"))