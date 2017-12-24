require 'deluge/daemon'

# https://stackoverflow.com/questions/471581/how-to-map-a-custom-protocol-to-an-application-on-the-mac/3704396#3704396
# http://www.macosxautomation.com/applescript/linktrigger/
# http://dev.deluge-torrent.org/wiki/Faq#HowdoIsetDelugeasmydefaultprogramforMagnetURIs
# https://github.com/Lord-Kamina/Deluge-Magnet-Handler/blob/master/README.md


desc "start deluge daemon"
task :start_deluge_daemon do
  Deluge::Daemon.start
end

desc "stop deluge daemon"
task :stop_deluge_daemon do
  Deluge::Daemon.stop
end

desc "play"
task :play do
  deluged = Deluge::Daemon.new

  puts deluged.rpc_client.daemon.info
  puts deluged.rpc_client.auth_level

  puts deluged.rpc_client.api_methods.sort.join("\n")

  puts deluged.rpc_client.core.remove_torrent('25da5c0b1d5db01009716f31481d89f7419b06c9', true)
  puts deluged.rpc_client.core.get_torrents_status({}, [])

end

desc "add magnet"
task :add_magnet do
  magnet_url = 'magnet:?xt=urn:btih:25DA5C0B1D5DB01009716F31481D89F7419B06C9&amp;tr=udp://glotorrents.pw:6969/announce&amp;tr=udp://tracker.opentrackr.org:1337/announce&amp;tr=udp://torrent.gresille.org:80/announce&amp;tr=udp://tracker.openbittorrent.com:80&amp;tr=udp://tracker.coppersurfer.tk:6969&amp;tr=udp://tracker.leechers-paradise.org:6969&amp;tr=udp://p4p.arenabg.ch:1337&amp;tr=udp://tracker.internetwarriors.net:1337'

  deluged = Deluge::Daemon.new

  #puts deluged.rpc_client.core.pretty_instance_info

  deluged.rpc_client.core.add_torrent_magnet(magnet_url, {})
end
