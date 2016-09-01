class StatisticsController < ApplicationController
  before_action :calcul_stats

  def index
  end

  def export
    csv = CSV.generate(col_sep: ';') do |csv|
      csv << %w(Mois Format Action Total)
      @stats.each do |month, stat|
        stat.each do |format, actions|
          actions.each do |action, count|
            csv << [I18n.t('date.month_names')[month.to_i].capitalize, format, action, count]
          end
        end
      end
    end
    send_data(csv, filename: "chouette_statistics_#{Time.current.to_i}.csv")
  end

  protected

  def calcul_stats
    ievkit = Ievkit::Job.new(nil)
    ievkit_stats = ievkit.get_stats
    @stats = {}
    dates = ievkit_stats['Stats'].map{ |s| s['date'].split('-')[1] }.compact.reject(&:blank?).uniq.sort
    formats = ievkit_stats['Stats'].map{ |s| s['format'] }.compact.reject(&:blank?).uniq.sort
    actions = ievkit_stats['Stats'].map{ |s| s['action'] }.compact.reject(&:blank?).uniq.sort

    dates.each do |d|
      @stats[d] ||= {}
      formats.each do |f|
        @stats[d][f] ||= {}
        actions.each do |a|
          count = ievkit_stats['Stats'].count{ |s| s['date'].match("-#{d}-") && s['action'] == a && s['format'] == f }
          @stats[d][f][a] = count if count > 0
        end
      end
    end
  end

end

# Date.strptime(s['date'], "%Y-%m-%d").strftime("%B")
