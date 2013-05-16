module Api
  module V1
    class ApiKey < ::ActiveRecord::Base
      before_create :generate_access_token
      belongs_to :referential, :class_name => '::Referential'

      def self.model_name
        ActiveModel::Name.new self, Api::V1, self.name.demodulize
      end

      def eql?(other)
        other.token == self.token
      end

      def self.referential_from_token(token)
        array = token.split('-')
        return nil unless array.size==2
        ::Referential.find( array.first)
      end

    private
      def generate_access_token
        begin
          self.token = "#{referential.id}-#{SecureRandom.hex}" 
        end while self.class.exists?(:token => self.token)
      end
    end
  end
end

