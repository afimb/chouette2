module JobsHelper

  def job_refresh_interval(job)
    job.started? ? 30 : 0
  end

end
