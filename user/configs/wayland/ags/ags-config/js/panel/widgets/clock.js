export default () => ags.Widget.Box({
    className: 'date',
    children: [
        ags.Widget.Icon({
            icon: 'x-office-calendar-symbolic', 
        }),

        ags.Widget.Label({
            connections: [
                [1000, label => ags.Utils.execAsync(['date', '+%a %d, %B  %H:%M'])
                    .then(date => label.label = ' ' + date).catch(console.error)],
            ],
        }),
    ],
});

