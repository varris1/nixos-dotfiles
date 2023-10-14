import { exec } from 'resource:///com/github/Aylur/ags/utils.js'

export function forMonitors(widget) {
    const ws = JSON.parse(exec('hyprctl -j monitors'));
    return ws.map(mon => widget(mon.id));
}
