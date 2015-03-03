module IevApi
  class Client

    PER_PAGE = 12
    #PARALLEL_WORKERS = 10
    ACTIONS = %w{ importer exporter validator }
    IMPORT_FORMAT = %w{ neptune netex gtfs }
    EXPORT_FORMAT = %w{ neptune netex gtfs hub kml }

    attr_accessor *IevApi::Configuration::VALID_OPTIONS_KEYS
    
    def initialize(options={})
      attrs = IevApi.options.merge(options)
      IevApi::Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", attrs[key])
      end
    end

    def url_for(endpoint, *args)
      path = case endpoint.to_s
             when 'jobs' then jobs_path(args)
             when 'job' then job_path(args)               
             when 'report' then report_path(args)
             else raise ArgumentError.new("Unrecognized path: #{path}")
             end

      [account_path, path.split('.').first].join('')
    end

    def jobs(referential_id, options = {})
      results = request(:get, jobs_path(referential_id), options)
      results.respond_to?(:jobs) ? results.jobs : []
    end
    
    def job(referential_id, job_id, options = {})
      results = request(:get, job_path(referential_id, job_id), options)
      if results.respond_to?(:job)
        results.job
      elsif results.respond_to?(:report)
        results.report
      else
        []
      end
    end
    
    def jobs_path(referential_id)
      "/referentials/#{referential_id}/jobs"
    end

    def job_path(referential_id, job_id)
      "/referentials/#{referential_id}/jobs/#{job_id}"
    end
    
    def report(referential_id, report_id, options = {})
      results = request(:get, report_path(referential_id, report_id), options)
      results.respond_to?(:report) ? results.report : []
    end
    
    def report_path(referential_id, report_id)
      "/referentials/#{referential_id}/reports/#{report_id}"
    end

    def account_path
      "#{protocol}://#{Rails.application.config.iev_url}"      
    end

    def protocol
      @secure ? "https" : "http"
    end
    
    # Perform an HTTP request
    def request(method, path, params = {}, options = {})
      
      action_and_format = (params[:action].present? && params[:format].present?) ? "/#{params[:action]}/#{params[:format]}" : ""      
      build_path = connection.path_prefix + path + action_and_format

      response = connection(options).run_request(method, nil, nil, nil) do |request|
        case method
        when :delete, :get
          request.url(build_path, params)
        when :post, :put
          request.url(build_path)
          request.body = params unless params.empty?
        end
      end

      response.body
    end

    def connection(options={})
      default_options = {
        :headers => {
          :accept => 'application/json',
          :user_agent => user_agent,
        },
        :ssl => {:verify => false},
        :url => account_path,
      }

      @connection ||= Faraday.new(default_options.deep_merge(connection_options)) do |builder|
        middleware.each { |mw| builder.use *mw }

        builder.adapter adapter
      end

      # cache_dir = File.join(ENV['TMPDIR'] || '/tmp', 'cache')

      # @connection.response :caching do  
      #   ActiveSupport::Cache::FileStore.new cache_dir, :namespace => 'iev',
      #   :expires_in => 3600  # one hour
      # end
    end
    
  end  
end
