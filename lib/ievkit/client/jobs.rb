module Ievkit
  class Client
    module Jobs

      # List jobs for a referential
      #
      # @param referential [String] Data referential name. 
      # @return [Array<Sawyer::Resource>] A list of jobs
      # @example Fetch all jobs for referential test
      #   client.jobs("test")
      def jobs(referential, options = {})
        paginate "chouette_iev/referentials/#{referential}/jobs", options
      end
      
      # Get scheduled job
      #
      # @param referential [String] Data referential name.
      # @param job_id [Integer] Id of the scheduled job.
      # @return [Sawyer::Resource] Hash representing scheduled job.
      # @example
      #   client.scheduled_job('test', 1451398)
      def scheduled_job(referential, job_id, options = {})
        get "chouette_iev/referentials/#{referential}/scheduled_jobs/#{job_id}", options
      end

      # Get terminated job
      #
      # @param referential [String] Data referential name.
      # @param job_id [Integer] Id of the terminated job.
      # @return [Sawyer::Resource] Hash representing terminated job.
      # @example
      #   client.terminated_job('test', 1451399)
      def terminated_job(referential, job_id, options = {})
        get "chouette_iev/referentials/#{referential}/terminated_jobs/#{job_id}", options
      end

      # Create job 
      #
      # @param referential [String] Data referential name.
      # @return [Sawyer::Resource] Hash representing the new job.
      # @example
      #   client.create_job("test",....)
      def create_job(referential, options = {})
        post "jobs", options
      end
      
    end
  end
end
