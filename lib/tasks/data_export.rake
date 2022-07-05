# frozen_string_literal: true

namespace :data do
  desc 'export data to the dump'
  task export: :environment do
    puts 'Exporting data'

    filepath = Rails.root.join('db/data.json')
    puts "=> exporting data into #{filepath}"

    data = {
      teams: Team.all,
      users: User.all.map do |u|
        u.as_json.merge(encrypted_password: u.encrypted_password)
      end,
      categories: Category.all,
      reports: Report.all,
      hours: Hour.all
    }.as_json

    File.write(filepath, JSON.pretty_generate(data))

    data.each do |object|
      puts "= exported #{object.last.map(&:length).length} #{object.first}"
    end
    puts '=> export completed'
  end
end
