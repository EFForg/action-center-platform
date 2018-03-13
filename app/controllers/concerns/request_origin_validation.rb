module RequestOriginValidation
  def verify_request_origin
    return if request.get? || request.head?

    # Accept blank origin headers because some user agents don't send it.
    origin = request.headers["origin"]
    unless origin.nil? || origin == request.base_url
      logger.warn "HTTP Origin header (#{origin.inspect}) didn't match request.base_url (#{request.base_url})"
      raise ActionController::InvalidCrossOriginRequest
    end
  end
end
