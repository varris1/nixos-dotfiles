import App from 'resource:///com/github/Aylur/ags/app.js'
import { exec } from 'resource://com/github/Aylur/ags/utils.js'
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';

import Panel from './js/panel/panel.js';
import NotificationsPopupWindow from './js/notifications/notificationPopup.js';
import { NotificationCenter } from './js/notifications/notificationCenter.js';

import {
    forMonitors
}
from './js/utils.js';

Notifications.clear();

const styleScss = App.configDir + '/style.scss';
const styleCss = '/tmp/style-ags.css';
exec(`sassc ${styleScss} ${styleCss}`);

export default {
    style: styleCss,
    windows: [
        forMonitors(Panel),
        NotificationsPopupWindow(),
        NotificationCenter(),
    ].flat(2),
};
