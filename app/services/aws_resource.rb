module AwsResource
    class << self
      def for(aws_service, options = {})
        aws_service::Resource.new(
          options.merge(
            access_key_id:  Rails.application.credentials.access_key_id,
            secret_access_key: Rails.application.credentials.secret_access_key,
            region: 'us-east-2',
        ))
      end
    end
  end
