export default player => ags.Widget.Button({
    className: 'media',
    onPrimaryClick: () => ags.Service.Mpris.getPlayer(player)?.playPause(),
    onScrollUp: () => ags.Service.Mpris.getPlayer(player)?.previous(),
    onScrollDown: () => ags.Service.Mpris.getPlayer(player)?.next(),

    child: ags.Widget.Box({
        children: [
            ags.Widget.Stack({
                items: [
                    ['paused', ags.Widget.Icon('media-playback-pause-symbolic')],
                    ['playing', ags.Widget.Icon('media-playback-start-symbolic')],
                    ['stopped', ags.Widget.Icon('media-playback-stop-symbolic')],
                ],

                connections: [[ags.Service.Mpris, statusIcon => {
                    const mpris = ags.Service.Mpris.getPlayer(player);

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
                }]],
            }),

            ags.Widget.Label({
                connections: [[ags.Service.Mpris, label => {
                    const mpris = ags.Service.Mpris.getPlayer(player);
                    if (!mpris || mpris.playBackStatus == "Stopped")
                    label.label = ' Stopped';
                    else 
                    label.label = ` ${mpris.trackArtists.join(', ')} - ${mpris.trackTitle}`;
                }]],
            }),
        ],
    }),
})


