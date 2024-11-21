import React from "react";
import ReactDOM from "react-dom";
import "./styles/index.css"; // CSS dosyasını burada import ediyoruz
import App from "./App";

ReactDOM.render(
    <React.StrictMode>
        <App />
    </React.StrictMode>,
    document.getElementById("root")
);
