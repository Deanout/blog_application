# run seed file based on environment
puts 'Seeding database'
load(Rails.root.join('db', 'seeds', "#{Rails.env.downcase}.rb"))
# load(Rails.root.join('db', 'seeds', 'state_country_seeds.rb'))
