# frozen_string_literal: true

%w[Research Development Support Vacation].each do |category_name|
  Category.find_or_create_by(name: category_name)
  puts "Created category #{category_name}"
end

%w[Managers Developers Administrators HR].each do |team_name|
  Team.find_or_create_by(name: team_name)
  puts "Created team #{team_name}"
end

User.find_or_create_by(email: 'admin@test.com') do |u|
  u.admin = true
  u.first_name = 'Test'
  u.last_name = 'Admin'
  u.password = 'P@ssword'
  u.rate = 100
  u.team_id = Team.find_by(name: 'Administrators').id
end
puts "Created default admin"
