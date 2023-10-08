const { Mpris, Hyprland, SystemTray, Audio } = ags.Service;
const { execAsync } = ags.Utils;
const { Box, Button, Label, Icon, CenterBox, Stack, Window } = ags.Widget;

const Workspaces = (monitor) => Box({
    className: 'workspaces',
    connections: [[Hyprland, box => {
        if (monitor == 0) {
            box.children = [1,2,3].map(i => Button({
                onClicked: () => execAsync(`hyprctl dispatch workspace ${i}`),
                onScrollDown: () => execAsync(`hyprctl dispatch workspace +1`),
                onScrollUp: () => execAsync(`hyprctl dispatch workspace -1`),
                child: Label({ label: `${i}` }),
                className: Hyprland.active.workspace.id == i ? 'focused' : '',
            }));
        } else if (monitor == 1) {
            box.children = [4,5,6].map(i => Button({
                onClicked: () => execAsync(`hyprctl dispatch workspace ${i}`),
                onScrollDown: () => execAsync(`hyprctl dispatch workspace +1`),
                onScrollUp: () => execAsync(`hyprctl dispatch workspace -1`),
                child: Label({ label: `${i}` }),
                className: Hyprland.active.workspace.id == i ? 'focused' : '',
            }));
        }
    }]],
});

const WindowTitle = () => Label({
    connections: [[Hyprland, label => {
        label.label = Hyprland.active.client.title || '';
        label.toggleClassName('windowTitle', label.label);
    }]],
});

const Volume = () => Button({
    className: 'volume',
    onScrollUp: () => execAsync('pamixer -i 10'),
    onScrollDown: () => execAsync('pamixer -d 10'),
    child: Box({
        children: [
            Stack({
                items: [
                    // tuples of [string, Widget]
                    ['101', Icon('audio-volume-overamplified-symbolic')],
                    ['67', Icon('audio-volume-high-symbolic')],
                    ['34', Icon('audio-volume-medium-symbolic')],
                    ['1', Icon('audio-volume-low-symbolic')],
                    ['0', Icon('audio-volume-muted-symbolic')],
                ],
                connections: [[Audio, stack => {
                    if (!Audio.speaker)
                    return;

                    if (Audio.speaker.isMuted) {
                        stack.shown = '0';
                        return;
                    }

                    const show = [101, 67, 34, 1, 0].find(
                        threshold => threshold <= Audio.speaker.volume * 100);

                    stack.shown = `${show}`;
                }, 'speaker-changed']],
            }),

            Label({
                connections: [[Audio, label => {
                    if (!Audio.speaker)
                    return;

                    label.label = ` ${Math.ceil((Audio.speaker.volume * 100) / 10) * 10}%`; // round up to nearest 10
                }, 'speaker-changed' ]],
            }),
        ],
    }),
});

const Media = () => Button({
    className: 'media',
    onPrimaryClick: () => Mpris.getPlayer('')?.playPause(),
    onScrollUp: () => Mpris.getPlayer('')?.previous(),
    onScrollDown: () => Mpris.getPlayer('')?.next(),

    child: Box({
        children: [
            Stack({
                items: [
                    ['paused', Icon('media-playback-pause-symbolic')],
                    ['playing', Icon('media-playback-start-symbolic')],
                    ['stopped', Icon('media-playback-stop-symbolic')],
                ],

                connections: [[Mpris, stack => {
                    const mpris = Mpris.getPlayer('');

                    switch (mpris.playBackStatus) {
                        case "Playing":
                            stack.shown = 'playing';
                            break;
                        case "Paused":
                            stack.shown = 'paused';
                            break;
                        default:
                            stack.shown = 'stopped';
                    }
                }]],
            }),

            Label({
                connections: [[Mpris, label => {
                    const mpris = Mpris.getPlayer('');
                    if (!mpris || mpris.playBackStatus == "Stopped")
                        label.label = ' Stopped';
                    else 
                        label.label = ` ${mpris.trackArtists.join(', ')} - ${mpris.trackTitle}`;
                }]],
            }),
        ],
    }),
})

const SysTray = () => Box({
    className: 'tray',
    connections: [[SystemTray, box => {
        box.children = SystemTray.items.map(item => Button({
            className: 'tray-icon',
            child: Icon(),
            onPrimaryClick: (_, event) => item.activate(event),
            onSecondaryClick: (_, event) => item.openMenu(event),
            connections: [[item, button => {
                button.child.icon = item.icon;
                button.tooltipMarkup = item.tooltipMarkup;
            }]],
        }));
    }]],
});

const Clock = () => Box({
    className: 'date',
    children: [
        Icon({
            icon: 'x-office-calendar-symbolic', 
        }),

        Label({
            connections: [
                [1000, label => execAsync(['date', '+%a %d, %B  %H:%M'])
                    .then(date => label.label = ' ' + date).catch(console.error)],
            ],
        }),
    ],
});

const Left = (monitor) => Box({
    children: [
        Workspaces(monitor),
        WindowTitle(),
    ],
});

const Center = () => Box({
    children: [
        Volume(),
        Media(),
    ],
});


const Right = () => Box({
    halign: 'end',
    children: [
        SysTray(),
        Clock(),
    ],
});

const Bar = ({ monitor } = {}) => Window({
    name: `bar-${monitor}`, // name has to be unique
    className: 'bar',
    monitor,
    anchor: ['top', 'left', 'right'],
    exclusive: true,
    child: CenterBox({
        startWidget: Left(`${monitor}`),
        centerWidget: Center(),
        endWidget: Right(),
    }),
})

const scss = ags.App.configDir + '/style.scss';
const css = '/tmp/style-ags.css';
ags.Utils.exec(`sassc ${scss} ${css}`);

export default {
    style: css,
    windows: [
        Bar({monitor: 0}),
        Bar({monitor: 1}),
    ],
};
