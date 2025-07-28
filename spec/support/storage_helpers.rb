module StorageHelpers
  def self.mock_fog!
    Fog.mock!
    Fog.credentials_path = Rails.root.join("spec/fixtures/fog_credentials.yml")
  end

  def self.unmock_and_stub!(pattern, ...)
    Fog.unmock!
    # this is the base of URLs generated without proper ENV secrets
    stub_url_base = "https://noop.s3-us-west-1.amazonaws.com"
    url_pattern = Regexp.new(stub_url_base + pattern.source)
    WebMock.stub_request(:any, url_pattern).to_return(...)
  end

  def self.disable_carrierwave_processing
    CarrierWave.configure { |c| c.enable_processing = false }
  end

  def self.enable_carrierwave_processing
    CarrierWave.configure { |c| c.enable_processing = true }
  end
end
