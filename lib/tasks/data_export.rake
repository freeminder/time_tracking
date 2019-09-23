namespace :dataexport do
  desc 'export data to the dump'
  task :recent_data => :environment do
    puts "Exporting data"

    filepath = File.join(Rails.root, 'db', 'recent_data.json')
    puts "=> exporting data into #{filepath}"

    data = {
      teams: Team.all,
      users: User.all,
      categories: Category.all,
      reports: Report.all,
      hours: Hour.all,
    }.as_json

    File.open(filepath, 'w') do |f|
      f.write(JSON.pretty_generate(data))
    end

    puts data.map { |object| "= exported #{object.last.map { |el| el.length }.length } #{object.first}" }
    puts "=> export completed"
  end
end
