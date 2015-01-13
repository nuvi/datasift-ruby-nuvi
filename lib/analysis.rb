module DataSift
  class Analysis < DataSift::ApiResource

    def valid?(csdl, boolResponse = true)
      params = {:csdl => csdl}
      requires params
      res = DataSift.request(:POST, 'analysis/validate', @config, params)
      boolResponse ? res[:http][:status] == 200 : res
    end

    def compile(csdl)
      params = {:csdl => csdl}
      requires params
      DataSift.request(:POST, 'analysis/compile', @config, params)
    end

    def get(hash = '')
      params = {:hash => hash}
      DataSift.request(:GET, 'analysis/get', @config, params)
    end

    def start(hash, name)
      params = {
        :hash => hash,
        :name => name
      }
      requires params
      DataSift.request(:POST, 'analysis/start', @config, params)
    end

    def stop(hash)
      params = {:hash => hash}
      requires params
      DataSift.request(:POST, 'analysis/stop', @config, params)
    end

    def analyze(hash, parameters, filter = '', start_time = '', end_time = '')
      params = {
        :hash                         => hash,
        :parameters                   => parameters,
      }
      requires params

      optional_params = {
        :filter                       => filter,
        :start                        => start_time,
        :end                          => end_time
      }
      params.merge! optional_params
      DataSift.request(:POST, 'analysis/analyze', @config, params)
    end

  end
end
