import { Label } from 'resource:///com/github/Aylur/ags/widget.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

export default () => Label({
    connections: [
        [Hyprland, label => {
            label.label = Hyprland.active.client.title || '';
            label.toggleClassName('windowTitle', label.label);
        }]
    ],
});
