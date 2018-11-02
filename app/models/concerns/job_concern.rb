module JobConcern
  extend ActiveSupport::Concern
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Model

  included do
    attr_reader :datas
  end

  module ClassMethods
  end

  def links
    {}.tap do |links|
      datas['links'].each do |link|
        links[link["rel"]] = link["href"]
      end
    end
  end

  def started?
    status == "started"
  end

  def aborted?
    status == "aborted"
  end

  def completed?
     %w{ aborted canceled terminated deleted}.include?(status)
  end

  def cache_key
   "#{id}_#{status}"
  end

  def cache_expiration
    started? ? 10.seconds : 1.hours
  end

  def id
    datas.id
  end

  def status
    datas.status.downcase
  end

  def referential_name
    datas.referential
  end

  def name
    datas.action_parameters.name
  end

  def user_name
    datas.action_parameters.user_name
  end

  def created_at
    Time.at(datas.created.to_i / 1000) if datas.created
  end

  def updated_at
    Time.at(datas.updated.to_i / 1000) if datas.updated
  end

  def format
    datas.type
  end

  def organisation_name
    datas.action_parameters.organisation_name
  end

  def no_save
    datas.action_parameters.no_save
  end
  alias_method :no_save?, :no_save

  def clean_repository
    datas.action_parameters.clean_repository
  end
end
