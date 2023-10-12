export default monitor => ags.Widget.Box({
    className: 'workspaces',
    connections: [[ags.Service.Hyprland, box => {
        if (monitor == 0) {
            box.children = [1,2,3].map(i => ags.Widget.Button({
                onClicked: () => ags.Utils.execAsync(`hyprctl dispatch workspace ${i}`),
                onScrollDown: () => ags.Utils.execAsync(`hyprctl dispatch workspace +1`),
                onScrollUp: () => ags.Utils.execAsync(`hyprctl dispatch workspace -1`),
                child: ags.Widget.Label({ label: `${i}` }),
                className: ags.Service.Hyprland.active.workspace.id == i ? 'focused' : '',
            }));
        } else if (monitor == 1) {
            box.children = [4,5,6].map(i => ags.Widget.Button({
                onClicked: () => ags.Utils.execAsync(`hyprctl dispatch workspace ${i}`),
                onScrollDown: () => ags.Utils.execAsync(`hyprctl dispatch workspace +1`),
                onScrollUp: () => ags.Utils.execAsync(`hyprctl dispatch workspace -1`),
                child: ags.Widget.Label({ label: `${i}` }),
                className: ags.Service.Hyprland.active.workspace.id == i ? 'focused' : '',
            }));
        }
    }]],
});


