// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$(function(){
  // リモートリンク
  $(document).on('ajax:success', 'a[data-update-target]', function(evt, data) {
    var target = $(this).data('update-target');
    $('#' + target).html(data);
  });

  // リモートフォーム
  $(document).on('ajax:success', 'form[data-update-target]', function(evt, data) {
    var target = $(this).data('update-target');
    $('#' + target).html(data);
  });
});

// トラックリスト更新
function refresh_track_list(playlist_id) {
  $.get(
    // 送信先
    "/playlists/" + playlist_id + "/track",
    // 送信データ
    null,
    // コールバック
    function(data, status) {
      $('#track_list').html(data);
    },
    // 応答データ形式
    "html"
  );
};
