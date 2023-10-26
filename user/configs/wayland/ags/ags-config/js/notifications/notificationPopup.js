import { Box, Window } from 'resource:///com/github/Aylur/ags/widget.js';
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';

import { Notification } from './notification.js';

const PopupList = () => Box({
    className: 'notificationPopupList',
    style: 'padding: 1px;', // so it shows up
    vertical: true,
    binds: [['children', Notifications, 'popups',
        popups => popups.map(Notification)]],
});

export default () => Window({
    name: 'notificationPopupWindow',
    anchor: ['right', 'top'],
    child: PopupList(),
});
