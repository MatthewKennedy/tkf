module Instrumentation
  module YabedaMetrics
    module_function

    def setup
      # timer_buckets = [ 0.01, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5]

      require("prometheus/client/support/puma")

      # Yabeda.configure do

      # end

      Prometheus::Client.configuration.pid_provider = Prometheus::Client::Support::Puma.method(:worker_pid_provider)
    end
  end
end
