import { Box, Button, Label } from 'resource:///com/github/Aylur/ags/widget.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

export default monitor => Box({
    className: 'workspaces',
    connections: [
        [Hyprland, box => {
            if (monitor == 0) {
                box.children = [1, 2, 3].map(i => Button({
                    onClicked: () => execAsync(`hyprctl dispatch workspace ${i}`),
                    onScrollDown: () => execAsync(`hyprctl dispatch workspace +1`),
                    onScrollUp: () => execAsync(`hyprctl dispatch workspace -1`),
                    child: Label({
                        label: `${i}`
                    }),
                    className: Hyprland.active.workspace.id == i ? 'focused' : '',
                }));
            } else if (monitor == 1) {
                box.children = [4, 5, 6].map(i => Button({
                    onClicked: () => execAsync(`hyprctl dispatch workspace ${i}`),
                    onScrollDown: () => execAsync(`hyprctl dispatch workspace +1`),
                    onScrollUp: () => execAsync(`hyprctl dispatch workspace -1`),
                    child: Label({
                        label: `${i}`
                    }),
                    className: Hyprland.active.workspace.id == i ? 'focused' : '',
                }));
            }
        }]
    ],
});
