import { Box, Button, Icon } from 'resource:///com/github/Aylur/ags/widget.js';
import SystemTray from 'resource:///com/github/Aylur/ags/service/systemtray.js';

export default () => Box({
    className: 'tray',
    connections: [
        [SystemTray, box => {
            box.children = SystemTray.items.map(item => Button({
                className: 'tray-icons',
                child: Icon({ binds: [['icon', item, 'icon']] }),
                onPrimaryClick: (_, event) => item.activate(event),
                onSecondaryClick: (_, event) => item.openMenu(event),
                connections: [
                    [item, button => {
                        button.child.icon = item.icon;
                        button.tooltipMarkup = item.tooltipMarkup;
                    }]
                ],
            }));
        }]
    ],
});
