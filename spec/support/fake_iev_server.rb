FakeWeb.allow_net_connect = false

DEFAULTS = {:content_type => "application/json; charset=utf-8", :status => ["403", "Forbidden"]}

def fixture_request(verb, url, file)
  FakeWeb.register_uri(verb, url, DEFAULTS.merge(:response => File.join( File.dirname(__FILE__), "../", 'fixtures', file)))
end

############
# Importer
############
# get list
fixture_request :get, "http://#{Rails.application.secrets.api_endpoint}referentials/test/scheduled_jobs?action=importer
", 'scheduled_jobs.json'
# get element
fixture_request :get, "http://#{Rails.application.secrets.api_endpoint}referentials/test/scheduled_jobs/1?action=importer
", 'scheduled_job.json'
# post element
fixture_request :post, "http://#{Rails.application.secrets.api_endpoint}referentials/test/scheduled_jobs/
", 'scheduled_job.json'

# Optionnels
# delete element
# cancel_element

# error on get element
# exception server not answer

############
# Exporter
############

############
# Validation
############



