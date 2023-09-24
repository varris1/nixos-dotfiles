const { Widget } = ags.Widget;
const { Mpris, Hyprland, SystemTray } = ags.Service;
const { execAsync } = ags.Utils;
const { Box, Button, Label, Icon, CenterBox, Window } = Widget;

const Workspaces = (monitor) => Box({
  className: 'workspaces',
  connections: [[Hyprland, box => {
    if (monitor == 0) {
      box.children = [1,2,3].map(i => Button({
        onClicked: () => execAsync(`hyprctl dispatch workspace ${i}`),
        child: Label({ label: `${i}` }),
        className: Hyprland.active.workspace.id == i ? 'focused' : '',
      }));
    } else if (monitor == 1) {
      box.children = [4,5,6].map(i => Button({
        onClicked: () => execAsync(`hyprctl dispatch workspace ${i}`),
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

const Media = () => Button({
  className: 'media',
  onPrimaryClick: () => Mpris.getPlayer('mpd')?.playPause(),
  onScrollUp: () => Mpris.getPlayer('mpd')?.previous(),
  onScrollDown: () => Mpris.getPlayer('mpd')?.next(),
  child: Label({
    connections: [[Mpris, label => {
      const mpris = Mpris.getPlayer('mpd');
      if (!mpris || mpris.playBackStatus == "Stopped")
        label.label = ' Stopped';
      else 
        label.label = `${mpris.playBackStatus == 'Playing' ? ' ' : '󰏤 '}${mpris.trackArtists.join(', ')} - ${mpris.trackTitle}`;
    }]],
  }),
});

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
    Label({
      label: ' ',
    }),
    Label({
      connections: [
        [1000, label => execAsync(['date', '+%a %d, %B  %H:%M'])
          .then(date => label.label = date).catch(console.error)],
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
    Media(),
  ],
});


const Right = () => Box({
  halign: 'end',
  children: [
    Clock(),
    SysTray(),
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
