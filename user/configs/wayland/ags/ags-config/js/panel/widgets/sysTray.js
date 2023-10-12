export default () => ags.Widget.Box({
    className: 'tray',
    connections: [[ags.Service.SystemTray, box => {
        box.children = ags.Service.SystemTray.items.map(item => ags.Widget.Button({
            className: 'tray-icon',
            child: ags.Widget.Icon(),
            onPrimaryClick: (_, event) => item.activate(event),
            onSecondaryClick: (_, event) => item.openMenu(event),
            connections: [[item, button => {
                button.child.icon = item.icon;
                button.tooltipMarkup = item.tooltipMarkup;
            }]],
        }));
    }]],
});


