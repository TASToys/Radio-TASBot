json.extract! request, :id, :songurl, :twitchname, :created_at, :updated_at
json.url request_url(request, format: :json)
