import Panel from './js/panel/panel.js';
import VolumeOSD from './js/volume_osd/volosd.js';

const scss = ags.App.configDir + '/style.scss';
const css = '/tmp/style-ags.css';
ags.Utils.exec(`sassc ${scss} ${css}`);

export default {
    style: css,
    windows: [
        Panel(0),
        Panel(1),

        // VolumeOSD(),
    ],
};
