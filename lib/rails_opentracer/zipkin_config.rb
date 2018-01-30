module RailsOpentracer
  class ZipkinConfig
    def self.opentracer_enabled?
      ENV['RAILS_OPENTRACER_ENABLED'] == 'yes'
    end

    def self.opentracer_enabled_and_zipkin_url_present?
      ENV['RAILS_OPENTRACER_ENABLED'] == 'yes' && ENV['ZIPKIN_SERVICE_URL'].present?
    end

    def self.zipkin_url
      if Rails.env.test? || Rails.env.development?
        'http://localhost:9411'
      else
        ENV['ZIPKIN_SERVICE_URL']
      end
    end
  end
end
