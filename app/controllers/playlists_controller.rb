class PlaylistsController < ApplicationController
  permits :user, :name, :playlist
  before_action :set_playlist, only: [:destroy, :search]

  # GET /playlists
  def index
    @playlists = Playlist.all
  end

  # GET /playlists/1
  def show(id, word, page)
    @playlist   = Playlist.includes(:tracks).order("tracks.created_at ASC").find(id)
    @tracks     = @playlist.tracks
    @unique_ids = @tracks.pluck(:unique_id)
    @word = word.presence || @playlist.name

    # トラックが1つも存在しなければ検索を行う
    unless @playlist.tracks.exists?
      @videos = Track.youtube_search(@word, @unique_ids, page)
    end

    # if word.present?
    #   # YouTube検索
    #   videos = YouTubeIt::Client.new.videos_by(query: word, order_by: 'viewCount', max_results: 50).videos
    #   # プレイリスト登録済み動画除外
    #   videos.delete_if{ |v| @unique_ids.index(v.unique_id) }
    #   @videos = Kaminari.paginate_array(videos).page(page).per(Settings.per_page)
    # else
    #   @videos = []
    # end
  end

  # # 動画追加
  # def video(id, word, video)
  #   playlist = Playlist.find_by(id: id, user_id: current_user.id)
  #   videos = YouTubeIt::Client.new.videos_by(query: word, page: 1, per_page: 3).videos

  #   track = Track.where(user_id: current_user.id, playlist_id: playlist.id, unique_id: video['unique_id'], provider: 'youtube').first_or_create(
  #     author_name: video['author_name'],
  #     duration: video['duration'],
  #     description: video['description'],
  #     title: video['title'],
  #     unique_id: video['unique_id'],
  #     published_at: video['published_at'],
  #     favorite_count: video['favorite_count'],
  #     view_count: video['view_count'],
  #     player_url: video['player_url']
  #   )

  #   render partial: '/playlists/add_button', locals: { track: track, playlist: playlist, word: word, videos: videos }
  # end

  # GET /playlists/new
  def new
    @playlist = Playlist.new
  end

  # GET /playlists/1/edit
  def edit(id)
    @playlist = Playlist.find(id)
  end

  # POST /playlists
  def create(playlist)
    @playlist = Playlist.new(playlist)
    @playlist.user = current_user

    if @playlist.save
      redirect_to @playlist, notice: 'Playlist was successfully created.'
    else
      render action: 'new'
    end
  end

  # PUT /playlists/1
  def update(id, playlist)
    @playlist = Playlist.find(id)

    if @playlist.update(playlist)
      redirect_to @playlist, notice: 'Playlist was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /playlists/1
  def destroy(id)
    current_user.playlists.find_by(id: id).destroy
    # @playlist = Playlist.find(id)
    # @playlist.mine.destroy

    redirect_to playlists_url
  end

  # Youtube検索
  def search(id, word, page)
    unique_ids = @playlist.tracks.mine(current_user).pluck(:unique_id)
    videos = Track.youtube_search(word, unique_ids, page)

    render partial: '/playlists/search_result', locals: { videos: videos, playlist: @playlist, word: word }
  end

  private

  # プレイリスト取得
  def set_playlist
    @playlist = Playlist.find_by(id: params[:id])
  end
end
