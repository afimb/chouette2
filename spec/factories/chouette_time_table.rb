FactoryGirl.define do

  factory :time_table_date, :class => Chouette::TimeTableDate do
  end

  factory :time_table_period, :class => Chouette::TimeTablePeriod do
  end

  factory :time_table, :class => Chouette::TimeTable do
    sequence(:comment) { |n| "Timetable #{n}" }
    sequence(:objectid) { |n| "objectid_#{n}" }
    sequence(:codespace) { |n| "codespace_#{n}" }
    sequence(:int_day_types) { (1..7).to_a.map{ |n| 2**(n+1)}.sum }

    transient do
      dates_count 4
      periods_count 4
    end

    after(:create) do |time_table, evaluator|

      0.upto(4) do |i|
        time_table.dates  << create(:time_table_date, :time_table => time_table, :date => i.days.since.to_date, :in_out => true)
      end

      start_date = Date.today
      end_date = start_date + 10

      0.upto(4) do |i|
        time_table.periods << create(:time_table_period, :time_table => time_table, :period_start => start_date, :period_end => end_date)
        start_date = start_date + 20
        end_date = start_date + 10
      end
      time_table.save_shortcuts
    end
  end

end
