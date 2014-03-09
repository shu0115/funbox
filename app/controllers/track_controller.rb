class TrackController < ApplicationController
  # Add時のPlayAll動画更新用
  def index(playlist_id)
    playlist = Playlist.includes(:tracks).mine(current_user).find_by(id: playlist_id)
    tracks   = playlist.tracks.order(created_at: :asc)

    render partial: '/playlists/play_all_area', locals: { playlist: playlist, tracks: tracks, unique_ids: Track.unique_ids(tracks, shuffle: false) }
  end

  # 動画追加
  def create(playlist_id, word, video, page)
    playlist = Playlist.find_by(id: playlist_id, user_id: current_user.id)

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

  # トラック削除
  def destroy(playlist_id, id)
    playlist = Playlist.find_by(id: playlist_id)
    tracks = playlist.tracks.order(created_at: :asc)

    track = Track.find_by(user_id: current_user.id, playlist_id: playlist_id, id: id)
    track.destroy

    render partial: '/playlists/tracks', locals: { playlist: playlist, tracks: tracks, unique_ids: Track.unique_ids(tracks, shuffle: false) }
  end
end
