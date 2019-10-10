# frozen_string_literal: true

namespace :data do
  desc 'import data from the dump'
  task import: :environment do
    puts 'Importing data'

    filepath = Rails.root.join('db', 'data.json')
    abort "Input file not found: #{filepath}" unless File.exist?(filepath)
    puts "=> importing data from #{filepath}"

    data = JSON.parse(File.read(filepath))

    data.each do |dataset|
      counter = 0
      dataset.last.each do |el|
        classname = Object.const_get dataset.first.singularize.capitalize
        next unless classname.where(id: el['id']).empty?

        classname.create(el)
        counter += 1
      end
      puts "= imported #{counter} #{dataset.first}"
    end

    puts '=> import completed'
  end
end
