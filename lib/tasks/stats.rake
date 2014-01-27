
namespace :stats do
  desc "send stats"
  task :send  => :environment  do
    puts "Send stats"

    File.open('/tmp/stats_users.csv','w') do |s|
      User.order(:id).each { |u| s.puts "#{u.id},#{u.organisation.name},#{u.name},#{u.email},#{u.sign_in_count},#{u.last_sign_in_at}"}
    end

    File.open('/tmp/stats_organisations.csv','w') do |s|
      Organisation.all.each { |o| s.puts "#{o.name},#{o.users.inject(0){ |memo, u| memo = memo + u.sign_in_count}},#{o.users.count}"}
    end

    File.open('/tmp/stats_counts.csv','w') do |s|
      [Organisation, User, Referential, Export, Import, FileValidation].each do |class_for_stat|
        stats = []
        stats << class_for_stat.all.select {|o| o.created_at.month==12 && o.created_at.year==2013}.count
        1.upto(12) do |i|
          stats << class_for_stat.all.select {|o| o.created_at.month==i && o.created_at.year==2014}.count
        end
        s.puts stats.join(",")
      end
    end

 #   m = ActionMailer::Base.mail(:to => "mflorisson@cityway.fr",
 #                               :from => "jdleca@cityway.fr",
 #                               :subject=>"Chouette stats",
 #                               :content_type=>"multipart/mixed")
 #   m.attachments['stats.csv'] = File.read("/tmp/stats.csv")
 #   m.deliver

    puts "Send stats complete"
  end
end

