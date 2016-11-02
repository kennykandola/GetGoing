json.extract! post, :id, :title, :offering, :body, :tags, :whos_traveling, :created_at, :updated_at
json.url post_url(post, format: :json)