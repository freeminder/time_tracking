namespace :dataimport do
  desc 'import data from the dump'
  task :recent_data => :environment do
    puts "Importing data"

    filepath = File.join(Rails.root, 'db', 'recent_data.json')
    abort "Input file not found: #{filepath}" unless File.exist?(filepath)
    puts "=> importing data from #{filepath}"

    data = JSON.parse(File.read(filepath))

    data.each do |dataset|
      counter = 0
      dataset.last.each do |el|
        classname = Object.const_get dataset.first.singularize.capitalize
        if classname.where(id: el["id"]).empty?
          # set user temp password, change later
          el = el.merge(password: SecureRandom.hex(16)) if dataset.first == "users"
          classname.create(el)
          counter += 1
        end
      end
      puts "= imported #{counter} #{dataset.first}"
    end

    puts "=> import completed"
  end
end
