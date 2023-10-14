const {
    Label,
    Window
} = ags.Widget;

export default () => Window({
    name: `volume-osd`,
    className: `osd`,
    monitor: null,
    focusable: false,
    anchor: ['center'],
    popup: true,

    child: Label('hello world'),
})