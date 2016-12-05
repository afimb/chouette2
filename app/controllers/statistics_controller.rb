class StatisticsController < ApplicationController
  before_action :check_authorize_admin
  before_action :calcul_stats

  def index
  end

  def export
    csv = CSV.generate(col_sep: ';') do |csv|
      csv << %w(Mois Action Format Total)
      @stats.each do |month, stat|
        stat.each do |action, formats|
          formats.each do |format, count|
            csv << [I18n.t('date.month_names')[month.to_i].capitalize, action, format, count]
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
      actions.each do |a|
        @stats[d][a] ||= {}
        formats.each do |f|
          count = ievkit_stats['Stats'].count{ |s| s['date'].match("-#{d}-") && s['action'] == a && s['format'] == f }
          @stats[d][a][f] = count if count > 0
        end
      end
    end
  end

end

# Date.strptime(s['date'], "%Y-%m-%d").strftime("%B")
