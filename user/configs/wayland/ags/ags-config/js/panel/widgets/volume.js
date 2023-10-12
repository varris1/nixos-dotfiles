export default () => ags.Widget.Button({
    className: 'volume',
    onScrollUp: () => ags.Utils.execAsync('pamixer -i 10'),
    onScrollDown: () => ags.Utils.execAsync('pamixer -d 10'),
    child: ags.Widget.Box({
        children: [
            ags.Widget.Stack({
                items: [
                    // tuples of [string, Widget]
                    ['101', ags.Widget.Icon('audio-volume-overamplified-symbolic')],
                    ['67', ags.Widget.Icon('audio-volume-high-symbolic')],
                    ['34', ags.Widget.Icon('audio-volume-medium-symbolic')],
                    ['1', ags.Widget.Icon('audio-volume-low-symbolic')],
                    ['0', ags.Widget.Icon('audio-volume-muted-symbolic')],
                ],
                connections: [[ags.Service.Audio, stack => {
                    if (!ags.Service.Audio.speaker)
                    return;

                    if (ags.Service.Audio.speaker.isMuted) {
                        stack.shown = '0';
                        return;
                    }

                    const show = [101, 67, 34, 1, 0].find(
                        threshold => threshold <= ags.Service.Audio.speaker.volume * 100);

                    stack.shown = `${show}`;
                }, 'speaker-changed']],
            }),

            ags.Widget.Label({
                connections: [[ags.Service.Audio, label => {
                    if (!ags.Service.Audio.speaker)
                    return;

                    label.label = ` ${Math.ceil((ags.Service.Audio.speaker.volume * 100) / 10) * 10}%`; // round up to nearest 10
                }, 'speaker-changed' ]],
            }),
        ],
    }),
});


