require 'rails/generators'

module RailsFaradayTracer
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)
      desc "Creates rails_faraday_tracer initializer for your application"

      def copy_initializer
        template "rails_opentracer_initializer.rb", "config/initializers/rails_opentracer.rb"
        puts "Initializer rails_opentracer added successfully"
      end

      def copy_faraday_tracer_middleware
        template "faraday_tracer.rb", "app/middleware/faraday_tracer.rb"
        puts "Faraday middleware added successfully"
      end

      def copy_tracer_middleware
        template "tracer.rb", "app/middleware/tracer.rb"
        puts "Tracer middleware added successfully"
      end
    end
  end
end
