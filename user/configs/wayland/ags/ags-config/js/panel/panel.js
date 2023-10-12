import Workspaces from './widgets/workspaces.js';
import WindowTitle from './widgets/windowTitle.js';
//
import Volume from './widgets/volume.js';
import Mpris from './widgets/mpris.js'
//
import SysTray from './widgets/sysTray.js';
import Clock from './widgets/clock.js';

const Left = monitor => ags.Widget.Box({
    children: [
        Workspaces(monitor),
        WindowTitle(),
    ],
});

const Center = () => ags.Widget.Box({
    children: [
        Volume(),
        Mpris('mpd')
    ],
});

const Right = () => ags.Widget.Box({
    halign: 'end',
    children: [
        SysTray(),
        Clock(),
    ],
});

export default monitor => ags.Widget.Window({
    name: `bar-${monitor}`, // name has to be unique
    className: 'bar',
    monitor,
    anchor: ['top', 'left', 'right'],
    exclusive: true,
    child: ags.Widget.CenterBox({
        startWidget: Left(`${monitor}`),
        centerWidget: Center(),
        endWidget: Right(),
    }),
})

