export default () => ags.Widget.Window({
    name: `volume-osd`,
    className: `osd`,
    monitor: null,
    focusable: false,
    anchor: [ 'center' ],
    popup: true,
    
    child: ags.Widget.Label('hello world'),
})
