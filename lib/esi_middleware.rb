
class EsiMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    original_logger_level = ActionController::Base.logger.level

    status, headers, body = @app.call(env)
    if headers["Content-Type"] =~ /^text\/html\b/
      ActionController::Base.logger.level = Logger::WARN

      includes = {}
      re = /<esi:include\s+src\=\"(.*?)\"\s*\/?>/i
      fixed_body = body.body.gsub(re) do |esi|
        path = esi.match(re)[1]

        unless includes[path]
          esi_status, esi_headers, esi_body = @app.call(env.merge("PATH_INFO" => path))

          if (200...300).include?(esi_status)
            includes[path] = esi_body.body
          else
            return [500, {}, ["Edge side include error: #{path} returned HTTP #{esi_status}"]]
          end
        end

        includes[path]
      end

      body = [fixed_body]
    end

    [status, headers, body]
  ensure
    ActionController::Base.logger.level = original_logger_level
  end
end
