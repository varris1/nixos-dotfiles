import { Box, CenterBox, Window } from 'resource:///com/github/Aylur/ags/widget.js';

import Workspaces from './widgets/workspaces.js';
import WindowTitle from './widgets/windowTitle.js';
//
import Volume from './widgets/volume.js';
import Mpris from './widgets/mpris.js'
//
import SysTray from './widgets/sysTray.js';
import Clock from './widgets/clock.js';

const Left = monitor => Box({
    children: [
        Workspaces(monitor), 
        WindowTitle(),
    ],
});

const Center = () => Box({
    children: [
        Volume(),
        Mpris('mpd'),
    ],
});

const Right = () => Box({
    hpack: 'end',
    children: [
        SysTray(), 
        Clock(),
    ],
});

export default monitor => Window({
    name: `bar-${monitor}`,
    exclusivity: "exclusive",
    className: 'bar',
    monitor,
    anchor: ['top', 'left', 'right'],
    child: CenterBox({
        startWidget: Left(monitor),
        centerWidget: Center(),
        endWidget: Right(),
    }),
})
