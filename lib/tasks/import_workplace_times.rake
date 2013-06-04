namespace :redmine do
  namespace :workplace_times do
desc <<-END_DESC
Import workplace times from text_file

Available options:
  * text_file     => text file(s) containing information about the workplace times (from ckyg)
Example:
  rake redmine:workplace_times:import_textfile text_file=/mnt/disk/text_file.txt RAILS_ENV="production"
*or*
  rake redmine:workplace_times:import_textfile text_file=/mnt/disk/*.txt RAILS_ENV="production"
END_DESC

    task :import_textfile => :environment do
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

desc <<-END_DESC
Import workplace times from text_file

Available options:
  * username     => username for gmail account
  * password     => password for gmail account
Example:
  rake redmine:workplace_times:import_pop3 username=test password=test RAILS_ENV="production"
END_DESC

    task :import_pop3 => :environment do
      if ENV['username'] && ENV['password']
        Mail.defaults do
          retriever_method :pop3, :address    => "pop.gmail.com",
                                  :port       => 995,
                                  :user_name  => ENV['username'],
                                  :password   => ENV['password'],
                                  :enable_ssl => true
        end
        while (mail = Mail.first)&& mail.present? do
          mail.attachments.each do |file|
            if file.filename[/\.csv$/]
              file.decoded.force_encoding("Windows-1251").encode("UTF-8").split("\r\n").select do |row|
                row[/^.\d{2}\.\d{2}.\d{4}/]
              end.each do |row|
                begin
                  array = row.split(";").map{ |str| str.gsub("\"",'') }.map{|str| str == "--" ? "00:00" : str.rstrip }
                  lastname, firstname, middlename = array[1].split(" ")
                  shift = 0
                  shift += 2 if array[3].blank?
                  p WorkplaceTime.create(
                    :user_id => User.where(:lastname => lastname).where("firstname LIKE ?", "%#{firstname}%").first.try(:id),
                    :workday => Date.parse(array[0]),
                    :start_time => Time.parse(array[shift+2]),
                    :end_time => Time.parse(array[shift+3]),
                    :duration => Time.parse(array[shift+4]),
                    :delay => Time.parse(array[shift+5])
                  )
                rescue
                  p array
                end
              end
            end
          end if mail.attachments.present?
        end
      end
    end
  end
end
