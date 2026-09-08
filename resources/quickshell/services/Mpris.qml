pragma Singleton
import Quickshell
import Quickshell.Services.Mpris
import QtQuick

Singleton {
    id: root

    property var preferredPlayers: ["kopuz", "helium"]

    property var playerList: Mpris.players ? Mpris.players.values : []

    function matches(pref, p) {
        return ((p?.identity) || "").toString().toLowerCase().includes(pref);
    }
    function isPlaying(p) {
        return p?.isPlaying === true;
    }

    property var player: {
        const list = playerList;
        if (!list || list.length === 0)
            return null;
        for (const pref of preferredPlayers) {
            const p = list.find(pl => matches(pref, pl) && isPlaying(pl));
            if (p) return p;
        }
        for (const pref of preferredPlayers) {
            const p = list.find(pl => matches(pref, pl));
            if (p) return p;
        }
        return list.find(pl => isPlaying(pl)) || list[0] || null;
    }

    readonly property string title: (player?.trackTitle || "").toString()
    readonly property string artist: (player?.trackArtist || "").toString()
    readonly property string album: (player?.trackAlbum || "").toString()
    readonly property bool active: !!player && player.playbackState !== MprisPlaybackState.Stopped
    readonly property string identity: (player?.identity || "").toString()
    readonly property string icon: {
        const id = identity.toLowerCase();
        if (id.includes("spotify"))
            return "";
        else if (id.includes("helium"))
            return "";
        else if (player !== null)
            return "";
        return "";
    }
    readonly property string artUrl: player?.trackArtUrl || ""

    function playPause() {
        if (!player) return;
        if (player.isPlaying === true) player.pause();
        else player.play();
    }
    function previous() { if (player) player.previous(); }
    function next() { if (player) player.next(); }
    function wheelVolume(up) {
        if (!player) return;
        if (up) player.volume = Math.min(1.0, player.volume + 0.05);
        else player.volume = Math.max(0.0, player.volume - 0.05);
    }
}
