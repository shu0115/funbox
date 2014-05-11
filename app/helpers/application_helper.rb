module ApplicationHelper
  # デフォルトMETAタグ
  def default_meta_tags
    {
      title:       'Funbox',
      description: 'Youtube Playlist Service',
      keywords:    '音楽 Youtube Music Playlist',
      separator:   '|'.html_safe,
      og: {
        title:       'Funbox',
        type:        'website',
        description: 'Youtube Playlist Service',
        url:         'https://funbox.herokuapp.com/',
        image:       asset_url('logo_180.png'),
        site_name:   'Funbox',
        locale:      'ja_JP',
      }
    }
  end

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
