import { Box, Button, Icon, Label, Stack } from 'resource:///com/github/Aylur/ags/widget.js';
import Mpris from 'resource:///com/github/Aylur/ags/service/mpris.js';

export default player => Button({
    className: 'media',
    onPrimaryClick: () => Mpris.getPlayer(player)?.playPause(),
    onScrollUp: () => Mpris.getPlayer(player)?.previous(),
    onScrollDown: () => Mpris.getPlayer(player)?.next(),

    child: Box({
        children: [
            Stack({
                items: [
                    ['paused', Icon('media-playback-pause-symbolic')],
                    ['playing', Icon('media-playback-start-symbolic')],
                    ['stopped', Icon('media-playback-stop-symbolic')],
                ],

                connections: [
                    [Mpris, statusIcon => {
                        const mpris = Mpris.getPlayer(player);

                        switch (mpris.playBackStatus) {
                            case "Playing":
                                statusIcon.shown = 'playing';
                                break;
                            case "Paused":
                                statusIcon.shown = 'paused';
                                break;
                            default:
                                statusIcon.shown = 'stopped';
                        }
                    }]
                ],
            }),

            Label({
                connections: [
                    [Mpris, label => {
                        const mpris = Mpris.getPlayer(player);
                        if (!mpris || mpris.playBackStatus == "Stopped")
                            label.label = ' Stopped';
                        else
                            label.label = ` ${mpris.trackArtists.join(', ')} - ${mpris.trackTitle}`;
                    }]
                ],
            }),
        ],
    }),
})
