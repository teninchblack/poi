{ROOT, jQuery, remote, $, $$, React, ReactBootstrap} = window

# Custom theme
config = remote.require './lib/config'
if theme = config.get 'poi.theme'
  $('#bootstrap-css').setAttribute 'href', "./assets/themes/#{theme}/css/#{theme}.css"
window.addEventListener 'theme.change', (e) ->
  theme = e.detail.theme
  $('#bootstrap-css').setAttribute 'href', "./assets/themes/#{theme}/css/#{theme}.css"

first = true

# Layout
adjustSize = ->
  $('kan-game webview')?.style?.height = $('kan-game webview /deep/ object[is=browserplugin]')?.style?.height = "#{window.innerHeight}px"
  webview = $('kan-game webview')
  url = webview.getUrl()
  return if url != 'http://www.dmm.com/netgame/social/-/gadgets/=/app_id=854854/'
  factor = Math.ceil(window.innerWidth / 7.0 * 5.0 / 800.0 * 100) / 100.0
  webview.executeJavaScript """
    var iframe = document.querySelector('#game_frame').contentWindow.document;
    document.querySelector('html').style.zoom = #{factor};
    iframe.querySelector('html').style.zoom = #{factor};
    window.scrollTo(0, 0);
    var x = document.querySelector('#game_frame').getBoundingClientRect().left + iframe.querySelector('embed').getBoundingClientRect().left;
    var y = document.querySelector('#game_frame').getBoundingClientRect().top + iframe.querySelector('embed').getBoundingClientRect().top;
    window.scrollTo(Math.ceil(x * #{factor}), Math.ceil(y * #{factor}));
    document.documentElement.style.overflow = 'hidden';
  """
  $('kan-game webview')?.style?.height = $('kan-game webview /deep/ object[is=browserplugin]')?.style?.height = "#{Math.floor(480 * factor)}px"
  $('kan-game').style.marginTop = "#{(window.innerHeight - 480 * factor) / 2.0}px"

window.addEventListener 'resize', (e) ->
  adjustSize()
# Hack CSS and Fix font family
$('kan-game webview').addEventListener 'page-title-set', (e) ->
  @insertCSS """
    * {
      font-family: Ubuntu, "WenQuanYi Micro Hei", "Microsoft YaHei" !important;
    }
    ::-webkit-scrollbar {
      width: 0px;
    }
  """
  adjustSize()
$('kan-game webview').addEventListener 'did-finish-load', (e) ->
  setTimeout adjustSize, 2000
