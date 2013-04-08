desc <<-END_DESC
Import workplace times from text_file

Available options:
  * text_file     => text file(s) containing information about the workplace times (from ckyg)
Example:
  rake redmine:import_workplace_times text_file=/mnt/disk/text_file.txt RAILS_ENV="production"
*or*
  rake redmine:import_workplace_times text_file=/mnt/disk/*.txt RAILS_ENV="production"

END_DESC

namespace :redmine do
  task :import_workplace_times => :environment do
    if ENV['text_file'].present?
      Dir[ENV['text_file']].each do |text_file|
        begin
          File.read(text_file).force_encoding("Windows-1251").encode("UTF-8").split("\n")[2..-1].each do |str|
            array = str.split("\t")
            lastname, firstname, middlename = array[1].split(" ")

            WorkplaceTime.create(
              :user_id => User.where(:lastname => lastname).where("firstname LIKE ?", "%#{firstname}%").first.try(:id),
              :workday => Date.parse(array[0]),
              :start_time => Time.parse(array[3]),
              :end_time => Time.parse(array[4]),
              :duration => Time.parse(array[5]),
              :delay => Time.parse(array[6])
            )
          end
        rescue
          puts("Wrong format of file: #{text_file}")
        end
      end
    end
  end
end
