class TransportMode
  class << self
    def formats
      %w(gtfs gtfs_extended netex neptune)
    end

    def all_modes(format)
      @all_modes = {}
      transport_mode_data(format).each do |tm|
        @all_modes[tm['mode']] ||= []
        @all_modes[tm['mode']] << tm['submode'] if tm['submode'] != 'unspecified'
      end
      @all_modes
    end

    def by_format(format = :gtfs)
      @all_modes = {}
      formats = [format]
      formats << :gtfs_extended if format == :gtfs
      formats.map { |f| format_label(f) }
      @all_modes
    end

    def format_label(format)
      format_t = I18n.t("enumerize.data_format.#{format}", default: format.to_s.humanize.upcase)
      @all_modes[format_t] = []
      transport_mode_data(format).each do |tm|
        label = I18n.t("transport_modes.gtfs.#{tm['mode'].parameterize}", default: tm['mode'])
        label_with_code = tm['code'] ? "#{label} (#{tm['code']})" : label
        @all_modes[format_t] << [label_with_code, label] unless @all_modes[format_t].find{ |k| k[1] == label }
      end
      @all_modes[format_t].uniq!
    end

    def submode(mode, format = :gtfs)
      @all_modes = []
      parse_json_file(mode, format)
      parse_json_file(mode, :gtfs_extended) if format == :gtfs
      @all_modes.uniq
    end

    def get_data_by_format(format)
      data = {}
      data_indexes = %w(inter_stop_area_distance_min_mode inter_stop_area_distance_max_mode speed_max_mode speed_min_mode inter_stop_duration_variation_max_mode)
      transport_mode_data(format).each do |tm|
        data[tm['mode'].parameterize('_')] ||= {}
        data[tm['submode'].parameterize('_')] ||= {}
        data_indexes.each do |di|
          data[tm['mode'].parameterize('_')]["#{di}_#{tm['mode'].parameterize('_')}".to_sym] = tm[di] unless tm['mode'] == 'unspecified'
          data[tm['submode'].parameterize('_')]["#{di}_#{tm['submode'].parameterize('_')}".to_sym] = tm[di] unless tm['submode'] == 'unspecified'
        end
      end
      data
    end

    def parse_json_file(mode, format)
      transport_mode_data(format).each do |tm|
        next unless tm['mode'] == mode
        next if tm['submode'].casecmp('unspecified').zero?
        label = I18n.t("transport_modes.gtfs.#{tm['submode'].parameterize}", default: tm['submode'])
        label_with_code = tm['code'] ? "#{label} (#{tm['code']})" : label
        @all_modes << [label_with_code, label]
      end
    end

    def transport_mode_data(format)
      @definitions_path ||= Gem.loaded_specs['chouette-projects-i18n'].full_gem_path
      JSON.parse(File.read(File.join(@definitions_path, 'data', 'transport_mode', "#{format}.json")))
    end
  end
end
