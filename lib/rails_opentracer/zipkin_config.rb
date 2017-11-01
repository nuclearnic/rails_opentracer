module RailsOpentracer
  class ZipkinConfig
    def self.zipkin_url

        


      if ENV['RAILS_OPENTRACER_ENABLED'] == 'yes'
        if ENV['ZIPKIN_SERVICE_URL'].present? 
          ENV['ZIPKIN_SERVICE_URL'] 
        else
           STDOUT.puts('TRACER_ERROR: `ZIPKIN_SERVICE_URL` environment variable is not defined') 
        end
      else
        STDOUT.puts('TRACER_ERROR: `RAILS_OPENTRACER_ENABLED` environment variable not set')
      end
    end
  end
end