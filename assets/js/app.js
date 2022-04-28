// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
import "../css/app.css"

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, { params: { _csrf_token: csrfToken } })

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket


window.addEventListener("phx:navigate", update_buttons, false)

async function update_buttons(e) {
    const old_buttons = document.getElementsByClassName("file-item-name");
    const buttons = document.getElementsByClassName("file-item-name file");
    for (const element of old_buttons) {
        element.removeEventListener("click", download);
    }
    for (const element of buttons) {
        element.addEventListener("click", download);
    }
}

function download(e) {
    let element = e.target
    let path = document.querySelector("meta[name='path']").getAttribute("content")
    fetch('/api/download', {
        method: 'post',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': csrfToken
        },
        body: JSON.stringify({ path: path, file: element.innerHTML })
    })
    .then(res => res.blob())
    .then(blob => {
        var url = window.URL.createObjectURL(blob);
        var a = document.createElement('a');
        a.href = url;
        a.download = element.innerHTML;
        document.body.appendChild(a); // we need to append the element to the dom -> otherwise it will not work in firefox
        a.click();
        a.remove();  //afterwards we remove the element again 
    });
}

let fileForm = document.getElementById("user_file");
let submitButton = document.getElementById("submit_file");
let progressBarContainer = document.getElementById("progress-bar-container");
let progressBarText = document.getElementsByClassName("progress-bar-text-percent")[0];
let progressBarFill = document.getElementsByClassName("progress-bar-fill")[0];




const axios = require('axios').default;
submitButton.addEventListener("click", function () {
    progressBarContainer.style.display = "block";
    progressBarText.innerHTML = "0%"
    progressBarFill.style.width = "0%";

    let file = fileForm.files[0];
    let formData = new FormData();
    let path = document.querySelector("meta[name='path']").getAttribute("content")

    formData.append("file", file);
    formData.append("path", path);
    axios.request({
        method: "post", 
        url: "/api/upload", 
        headers: {
            'X-CSRF-Token': csrfToken
        },
        data: formData, 
        onUploadProgress: (p) => {
            progressBarText.innerHTML = ((p.loaded / p.total) * 100).toFixed(2) + "%";
            progressBarFill.style.width = ((p.loaded / p.total) * 100).toFixed(2) + "%";;
        }
    }).then (data => {
        progressBarText.innerHTML = "100%"
        progressBarContainer.style.display = "none";
    })
    /*fetch('/api/upload', {
        method: "POST",
        headers: {
            'X-CSRF-Token': csrfToken
        },
        body: formData
    });*/
});