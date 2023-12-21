import { Box, Button, Icon, Label, Stack } from 'resource:///com/github/Aylur/ags/widget.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

export default () => Button({
    className: 'volume',
    onScrollUp: () => execAsync('pamixer -i 10'),
    onScrollDown: () => execAsync('pamixer -d 10'),

    child: Box({
        children: [
            Stack({
                items: [
                    // tuples of [string, Widget]
                    ['67', Icon('audio-volume-high-symbolic')],
                    ['34', Icon('audio-volume-medium-symbolic')],
                    ['1', Icon('audio-volume-low-symbolic')],
                    ['0', Icon('audio-volume-muted-symbolic')],
                ],
                connections: [
                    [Audio, stack => {
                        if (!Audio.speaker)
                            return;

                        if (Audio.speaker.isMuted) {
                            stack.shown = '0';
                            return;
                        }

                        const show = [101, 67, 34, 1, 0].find(
                            threshold => threshold <= Audio.speaker.volume * 100);

                        stack.shown = `${show}`;
                    }, 'speaker-changed']
                ],
            }),

            Label({
                connections: [
                    [Audio, label => {
                        if (!Audio.speaker)
                            return;

                        label.label = ` ${Math.floor((Audio.speaker.volume * 100) / 5) * 5}%`; // round down to nearest 5
                    }, 'speaker-changed']
                ],
            }),
        ],
    }),
});
