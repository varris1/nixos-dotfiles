import { Box, Icon, Label } from 'resource:///com/github/Aylur/ags/widget.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

export default () => Box({
    className: 'date',
    children: [
        Icon({
            icon: 'x-office-calendar-symbolic',
        }),

        Label({
            connections: [
                [1000, label => execAsync(['date', '+%a %d, %B  %H:%M'])
                    .then(date => label.label = ' ' + date).catch(console.error)
                ],
            ],
        }),
    ],
});
