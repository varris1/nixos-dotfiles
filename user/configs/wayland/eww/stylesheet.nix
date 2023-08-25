{
  eww-stylesheet = ''
      $bg: rgba(40,40,40,0.8);
      $fg: rgb(235,219,178);

      $wsfg: rgb(235,219,178);
      $wsbg: rgb(60,56,54);
      $activewsbg: rgb(102,92,84);


      $box-bg: rgb(80,73,69);

      * {
        all: unset; //Unsets everything so you can style everything from scratch
      }

      //Global Styles
      .bar {
        background-color: $bg;
        color: $fg;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 12px;
      }

      .window {
        background-color: $box-bg;
        border-radius: 10px;
        padding: 0px 10px 0px 10px;
        margin: 5px 0px 5px 10px;
      }

      .volume {
        background-color: $box-bg;
        border-radius: 10px 0px 0px 10px;
        margin: 5px 0px 5px 0px;
        padding: 0px 10px 0px 10px;
      }

      .mpd {
        background-color: $box-bg;
        border-radius: 0px 10px 10px 0px;
        padding: 0px 10px 0px 10px;
        margin: 5px 10px 5px 0px;
      }

      .tray {
        background-color: $box-bg;
        border-radius: 10px;
        padding: 0px 10px 0px 10px;
        margin: 5px 10px 5px 0px;
      }

      .date {
        background-color: $box-bg;
        border-radius: 10px;
        padding: 0px 10px 0px 10px;
        margin: 5px 10px 5px 0px;
      }

      .wswidget {
        background-color: $box-bg;
        border-radius: 10px;
        margin: 5px 0px 5px 10px;
      }

      .w0, .w01, .w02, .w03, .w04, .w05, .w06, .w07, .w08, .w09, .w011, .w022, .w033, .w044, .w055, .w066, .w077, .w088, .w099 {
        background-color: $wsbg;
        padding: 3px 10px;
      }

      .w01, .w011, .w04, .w044 {
        background-color: $wsbg;
        border-radius: 10px 0px 0px 10px;
      }

      .w03, .w033, .w06, .w066 {
        background-color: $wsbg;
        border-radius: 0px 10px 10px 0px;
      }

      /* Occupied */
      .w01, .w02, .w03, .w04, .w05, .w06, .w07, .w08, .w09 {
        background-color: $wsbg;
      }

      /* Focused */
      .w011, .w022, .w033, .w044, .w055, .w066, .w077, .w088, .w099 {
        background-color: $activewsbg;
      }

    '';
}
