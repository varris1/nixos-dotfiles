import App from 'resource:///com/github/Aylur/ags/app.js'
import { exec } from 'resource://com/github/Aylur/ags/utils.js'

import Panel from './js/panel/panel.js';
import {
    forMonitors
}
from './js/utils.js';

const scss = App.configDir + '/style.scss';
const css = '/tmp/style-ags.css';
exec(`sassc ${scss} ${css}`);

export default {
    style: css,
    windows: [
        forMonitors(Panel),
    ].flat(2),
};
