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
//= require cyborg/loader
//= require cyborg/bootswatch

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

  // ツールチップ
  $('a[rel=tooltip]').tooltip();
  $('a[rel=popover]').popover({ html: true, placement: 'top', trigger: 'hover' });

  // オートページャー
  if ($('#autopager_on').val() == 'true') { autopager(); };
});

// プレイオール更新
function refresh_track_list(playlist_id) {
  $.get(
    // 送信先
    "/playlists/" + playlist_id + "/track",
    // 送信データ
    null,
    // コールバック
    function(data, status) {
      $('#play_all_area').html(data);
    },
    // 応答データ形式
    "html"
  );
};

// オートページャー
function autopager() {
  $(window).scroll(function() {
    var obj = $(this);
    var current = $(window).scrollTop() + window.innerHeight;
    if (current < $(document).height() - 400) return; // 下部に達していなければリターン
    if (obj.data('loading')) { return };  // ロード中であればリターン

    // パラメータ
    var page          = parseInt($('#current_page').val());
    var next_page     = page + 1
    var total_page    = parseInt($('#num_pages').val());
    var playlist_id   = $('#playlist_id').val();
    var word          = $('#word').val();

    if (page < total_page) {
      obj.data('loading', true);  // ローディングフラグON
      $("#search_result_area_loading").show()
      $.get(
        "/playlists/" + playlist_id + "/search_pager",
        // 送信データ
        { 'page': next_page, 'word': word },
        function(data, status) {
          $("#search_result_area_loading").hide();
          $('#page_' + page).after(data);  // データ追加
          $('#current_page').val(next_page);
          obj.data('loading', false);      // ローディング解除
        },
        "html"                             // 応答データ形式
      );
    };
  });
}
