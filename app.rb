require 'google/apis/youtube_v3'

# youtubeリクエスト
youtube = Google::Apis::YoutubeV3::YouTubeService.new
youtube.key = ""
channel_lists = youtube.list_channels('contentDetails', id: "")
uploads = channel_lists.items[0].content_details.related_playlists.uploads
videos = youtube.list_playlist_items('snippet', playlist_id: uploads, max_results: 10)
url_array = []
videos.items.each do |video|
  url_array << video.snippet.thumbnails.maxres.url
end

# 画像を保存
require 'open-uri'
url_array.each_with_index do |url, i|
  file_name = "#{i}.png"
  dir_name = "/image/"
  file_path = dir_name + file_name
  FileUtils.mkdir_p(dir_name) unless FileTest.exist?(dir_name)
  URI.open(file_path, 'wb') do |pass|
    URI.open(url) do |recieve|
      pass.write(recieve.read)
    end
  end
end



