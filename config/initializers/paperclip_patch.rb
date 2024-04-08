# Monkeypatch paperclip's media type detection
Rails.application.reloader.to_prepare do
  Paperclip::MediaTypeSpoofDetector.prepend MonkeyPatches::OctetStreamOverride
end
