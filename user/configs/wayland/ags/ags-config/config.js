import App from 'resource:///com/github/Aylur/ags/app.js'
import { exec } from 'resource://com/github/Aylur/ags/utils.js'

import Panel from './js/panel/panel.js';

import {
    forMonitors
}
from './js/utils.js';

const styleScss = App.configDir + '/style.scss';
const styleCss = '/tmp/style-ags.css';
exec(`sassc ${styleScss} ${styleCss}`);

export default {
    style: styleCss,
    windows: [
        forMonitors(Panel),
    ].flat(2),
};
