export default () => ags.Widget.Label({
    connections: [[ags.Service.Hyprland, label => {
        label.label = ags.Service.Hyprland.active.client.title || '';
        label.toggleClassName('windowTitle', label.label);
    }]],
});


