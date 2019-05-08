# Monkeypatch paperclip's media type detection
Paperclip::MediaTypeSpoofDetector.prepend MonkeyPatches::OctetStreamOverride
