class PlaylistsController < ApplicationController
  permits :user, :name, :playlist
  before_action :set_playlist, only: [:destroy, :search, :search_pager]

  # GET /playlists
  def index(user_id: current_user.id)
    @playlists = Playlist.where(user_id: user_id).order(created_at: :desc)
    @playlist  = Playlist.new
  end

  # GET /playlists/1
  def show(id, word, page, search: true)
    @playlist   = Playlist.includes(:tracks).order("tracks.created_at ASC").find(id)
    @tracks     = @playlist.tracks
    @unique_ids = @tracks.pluck(:unique_id)
    @word = word.presence || @playlist.name

    # ×トラックが1つも存在しなければ検索を行う
    # if search.present? or !(@playlist.tracks.exists?)
    if search.present?
      @videos = Track.youtube_search(@word, @unique_ids, page)
    end
  end

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
    @playlist.save!

    redirect_to playlists_path and return
  end

  # PUT /playlists/1
  def update(id, playlist)
    @playlist = Playlist.find(id)

    if @playlist.update(playlist)
      # redirect_to @playlist, notice: 'Playlist was successfully updated.'
      redirect_to playlists_path and return
    else
      render action: 'edit'
    end
  end

  # DELETE /playlists/1
  def destroy(id)
    current_user.playlists.find_by(id: id).destroy

    redirect_to playlists_url
  end

  # Youtube検索
  def search(id, word, page)
    unique_ids = @playlist.tracks.mine(current_user).pluck(:unique_id)
    videos = Track.youtube_search(word, unique_ids, page)

    render partial: '/playlists/search_result', locals: { videos: videos, playlist: @playlist, word: word }
  end

  # Youtube検索オートページャー
  def search_pager(id, word, page)
    unique_ids = @playlist.tracks.mine(current_user).pluck(:unique_id)
    videos = Track.youtube_search(word, unique_ids, page)

    render partial: '/playlists/search_pager', locals: { videos: videos, playlist: @playlist, word: word }
  end

  # プレイリストプレイオール
  def all
    @tracks = Track.where(id: Track.mine(current_user).pluck(:id).shuffle.first(100))
    @unique_ids   = Track.unique_ids(@tracks, shuffle: true)
    @tracks_hash  = @tracks.index_by{ |x| x.unique_id }
  end

  private

  # プレイリスト取得
  def set_playlist
    @playlist = Playlist.find_by(id: params[:id])
  end
end
