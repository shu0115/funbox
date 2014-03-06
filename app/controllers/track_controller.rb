class TrackController < ApplicationController
  # トラック一覧
  def index(playlist_id)
    playlist = Playlist.find_by(id: playlist_id)
    tracks   = Track.where(user_id: current_user.id, playlist_id: playlist.id)

    render partial: '/playlists/tracks', locals: { tracks: playlist.tracks }
  end

  # 動画追加
  def create(playlist_id, word, video, page)
    playlist = Playlist.find_by(id: playlist_id, user_id: current_user.id)
    # videos = YouTubeIt::Client.new.videos_by(query: word, order_by: 'viewCount', page: page, per_page: Settings.per_page).videos

    track = Track.where(user_id: current_user.id, playlist_id: playlist.id, unique_id: video['unique_id'], provider: 'youtube').first_or_create(
      author_name: video['author_name'],
      duration: video['duration'],
      description: video['description'],
      title: video['title'],
      unique_id: video['unique_id'],
      published_at: video['published_at'],
      favorite_count: video['favorite_count'],
      view_count: video['view_count'],
      player_url: video['player_url'],
    )

    render partial: '/playlists/add_video', locals: { v: nil, playlist: playlist }
  end

  def destroy(playlist_id, id)
    playlist = Playlist.find_by(id: playlist_id)
    track = Track.find_by(user_id: current_user.id, playlist_id: playlist_id, id: id)
    track.destroy

    render partial: '/playlists/tracks', locals: { tracks: playlist.tracks }
  end
end
