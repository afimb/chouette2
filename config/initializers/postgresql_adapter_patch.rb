module ::ArJdbc
  module PostgreSQL
    def quote_column_name(name)
      if name.is_a?(Array)
        name.collect { |n| %("#{n.to_s.gsub("\"", "\"\"")}") }.join(',')
      else
        %("#{name.to_s.gsub("\"", "\"\"")}")
      end
    end
  end
end
