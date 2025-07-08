module StorageHelpers
  def self.mock_fog!
    Fog.mock!
    Fog.credentials_path = Rails.root.join("spec/fixtures/fog_credentials.yml")
  end

  def self.disable_carrierwave_processing
    CarrierWave.configure { |c| c.enable_processing = false }
  end

  def self.enable_carrierwave_processing
    CarrierWave.configure { |c| c.enable_processing = true }
  end
end
