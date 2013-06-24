# config/initializers/delayed_job_config.rb
#Delayed::Job.destroy_failed_jobs = false
silence_warnings do
  Delayed::Job.const_set("MAX_ATTEMPTS", 1)
  Delayed::Job.const_set("MAX_RUN_TIME", 12.hours)
end