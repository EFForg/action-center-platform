json.array!(@partners) do |partner|
  json.extract! partner, :id
  json.url partner_url(partner, format: :json)
end
