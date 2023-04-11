require 'google/apis/youtube_v3'

# 好きなYouTubeチャンネルの動画情報を取得
youtube = Google::Apis::YoutubeV3::YouTubeService.new
youtube.key = "ここに自分のYouTubeAPIを入れる"
channel_lists = youtube.list_channels('contentDetails', id: "ここにチャンネルIDを入れる")
uploads = channel_lists.items[0].content_details.related_playlists.uploads
videos = youtube.list_playlist_items('snippet', playlist_id: uploads, max_results: 10) # 取得数(1~50)

# open-uri用の配列を準備
url_array = []
videos.items.each do |video|
  url_array << video.snippet.thumbnails.maxres.url
end

# 画像を指定の場所に保存
require 'open-uri'
url_array.each_with_index do |url, i|
  file_name = "#{i}.png"
  dir_name = "/app/image/"
  file_path = dir_name + file_name
  FileUtils.mkdir_p(dir_name) unless FileTest.exist?(dir_name)
  URI.open(file_path, 'wb') do |pass|
    URI.open(url) do |recieve|
      pass.write(recieve.read)
    end
  end
end
