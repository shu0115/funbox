module ApplicationHelper
  def playlists_active?(params)
    return true if params[:controller] == 'playlists' and (params[:action] == 'index' or params[:action] == 'show')
    return false
  end

  def play_all_active?(params)
    return true if params[:controller] == 'playlists' and params[:action] == 'all'
    return false
  end

  def recent_active?(params)
    return true if params[:controller] == 'playlists' and params[:action] == 'recent'
    return false
  end

  def popular_active?(params)
    return true if params[:controller] == 'playlists' and params[:action] == 'popular'
    return false
  end
end
