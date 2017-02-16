#(Iteration 0)

#ruby event_manager.rb
# puts "EventManager Initialized!"

# lines = File.readlines "../event_attendees.csv"
# lines.each_with_index do |line, row_index|
#   next if index ==0
#   columns = line.split(",")[2]
#   name = columns[2]
#   puts name
# end
#___________________________________________________
#(Iteration 1-2)

# require "csv"
# puts "EventManager initialized."

# contents = CSV.open "../event_attendees.csv", headers: true, header_converters: :symbol
# contents.each do |row|
#   name = row[:first_name]
#   zipcode = row[:zipcode]

#   if zipcode.nil?
#     zipcode = "00000"
#   elsif zipcode.length < 5
#     zipcode = zipcode.rjust 5, "0"
#   elsif zipcode.length > 5
#     zipcode = zipcode[0..4]
#   end

#   puts "#{name} #{zipcode}"
# end

# def clean_zipcode(zipcode)
#   zipcode.to_s.rjust(5,"0")[0..4]
# end

# puts "EventManager initialized."

# contents = CSV.open '../event_attendees.csv', headers: true, header_converters: :symbol

# contents.each do |row|
#   name = row[:first_name]

#   zipcode = clean_zipcode(row[:zipcode])

#   puts "#{name} #{zipcode}"
# end
#______________________________________________________
#(Iteration 3)

require 'csv'
require 'sunlight/congress'
require 'erb'

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5,"0")[0..4]
end

def legislators_by_zipcode(zipcode)
  Sunlight::Congress::Legislator.by_zipcode(zipcode)
end

puts "EventManager initialized."

contents = CSV.open 'event_attendees.csv', headers: true, header_converters: :symbol

template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter

contents.each do |row|
  name = row[:first_name]

  zipcode = clean_zipcode(row[:zipcode])

  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)
  puts form_letter
end

#___________________________________________________________________
#(Iteration 4)

template_letter = File.read "form_letter.html"

contents.each do |row|
  id = row[0]
  name = row[:first_name]

  zipcode = clean_zipcode(row[:zipcode])

  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  Dir.mkdir("output") unless Dir.exists? "output"

  filename = "output/thanks_#{id}.html"

  File.open(filename,'w') do |file|
    file.puts form_letter
  end

end