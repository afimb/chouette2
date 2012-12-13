module Api
  module V1
    class ApiKey < ::ActiveRecord::Base
      before_create :generate_access_token
      belongs_to :referential, :class_name => '::Referential'

      def eql?(other)
        other.token == self.token && other.referential_id == self.referential_id
      end

    private
      def generate_access_token
        begin
          self.token = SecureRandom.hex
          puts "self.token=#{self.token}"
        end while self.class.exists?(:token => self.token)
      end
      def organisation
        @organisation ||= Organisation.find_by_id @organisation_id
      end 
    end
  end
end

