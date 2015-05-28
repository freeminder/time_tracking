[
  "Research",
  "Development",
  "Support",
  "Vacation",
].each do |category_name|
  Category.create!(name: category_name)
  puts "Created category #{category_name}"
end

[
  "Managers",
  "Developers",
  "Administrators",
  "HR",
].each do |team_name|
  Team.create(name: team_name)
  puts "Created team #{team_name}"
end
